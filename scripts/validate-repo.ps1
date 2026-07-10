param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$failures = [System.Collections.Generic.List[string]]::new()

function Add-Failure {
    param([string]$Message)
    $failures.Add($Message)
}

function Get-FirstFile {
    param(
        [string]$Path,
        [string]$Filter,
        [switch]$Recurse
    )

    $params = @{
        LiteralPath = $Path
        File = $true
        Filter = $Filter
    }
    if ($Recurse) {
        $params.Recurse = $true
    }
    return Get-ChildItem @params | Select-Object -First 1
}

function Test-SkillFrontmatter {
    param(
        [string]$Path,
        [string]$ExpectedName
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        Add-Failure "Missing platform Skill file: $Path"
        return
    }

    $content = Get-Content -Raw -Encoding utf8 -LiteralPath $Path
    if ($content -notmatch '(?s)^---\r?\n(.*?)\r?\n---\r?\n') {
        Add-Failure "Skill has no YAML frontmatter: $Path"
        return
    }

    $frontmatter = $Matches[1]
    if ($frontmatter -notmatch "(?m)^name:\s*$([regex]::Escape($ExpectedName))\s*$") {
        Add-Failure "Skill frontmatter has the wrong name: $Path"
    }
    if ($frontmatter -notmatch '(?m)^description:\s*\S.+$') {
        Add-Failure "Skill frontmatter has no usable description: $Path"
    }

    $allowedKeys = @("name", "description", "license", "metadata", "allowed-tools")
    foreach ($keyMatch in [regex]::Matches($frontmatter, '(?m)^([a-z][a-z0-9-]*):')) {
        $key = $keyMatch.Groups[1].Value
        if ($key -notin $allowedKeys) {
            Add-Failure "Skill frontmatter contains unsupported key '$key': $Path"
        }
    }
}

function Test-XMindArchive {
    param([string]$Path)

    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $archive = [IO.Compression.ZipFile]::OpenRead($Path)
        try {
            $entries = @($archive.Entries.FullName)
            if (($entries -notcontains 'content.json') -and ($entries -notcontains 'content.xml')) {
                Add-Failure "XMind archive has no content entry: $Path"
            }
        }
        finally {
            $archive.Dispose()
        }
    }
    catch {
        Add-Failure "Invalid XMind archive: $Path"
    }
}

Push-Location $repoRoot
try {
    $qaSummary = Get-FirstFile -Path qa -Filter "06_*.md"
    $toolIndex = Get-FirstFile -Path qa -Filter "04_*.md"
    $t08 = Get-FirstFile -Path qa -Filter "T08_*.md" -Recurse
    $t10 = Get-FirstFile -Path qa -Filter "T10_*.md" -Recurse

    $qaOverview = Get-ChildItem -LiteralPath qa -File -Filter "00_*.md" |
        Where-Object {
            (Get-Content -Raw -Encoding utf8 -LiteralPath $_.FullName) -match '45.*Skill'
        } |
        Select-Object -First 1

    foreach ($resolved in @(
        @{ Name = "QA summary"; Value = $qaSummary },
        @{ Name = "QA overview"; Value = $qaOverview },
        @{ Name = "tool index"; Value = $toolIndex },
        @{ Name = "T08"; Value = $t08 },
        @{ Name = "T10"; Value = $t10 }
    )) {
        if ($null -eq $resolved.Value) {
            Add-Failure "Could not resolve required file: $($resolved.Name)"
        }
    }

    $generatorPath = ".claude/skills/generate-testcase/SKILL.md"
    if (-not (Test-Path -LiteralPath $generatorPath)) {
        Add-Failure "Missing generator Skill: $generatorPath"
        $generatorSpec = ""
    }
    else {
        $generatorSpec = Get-Content -Raw -Encoding utf8 -LiteralPath $generatorPath
    }

    $standardMatch = [regex]::Match($generatorSpec, '`([^`]*\.md)`\s*\r?\n\s*-\s*As the testcase grading|(?m)^2\. `([^`]+\.md)`')
    $standardPath = $null
    foreach ($group in $standardMatch.Groups) {
        if ($group.Success -and $group.Value.EndsWith('.md')) {
            $standardPath = $group.Value
        }
    }
    if (-not $standardPath) {
        $fallback = [regex]::Match($generatorSpec, '(?m)^2\. `([^`]+\.md)`')
        if ($fallback.Success) {
            $standardPath = $fallback.Groups[1].Value
        }
    }

    $requiredFiles = @(
        "README.md",
        "LICENSE",
        "openspec/README.md",
        "testcases/README.md"
    )
    if ($standardPath) {
        $requiredFiles += $standardPath
    }
    else {
        Add-Failure "Could not resolve the mandatory testcase standard from the generator Skill."
    }

    foreach ($path in $requiredFiles) {
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
            Add-Failure "Missing required file: $path"
        }
    }

    $skillDocs = Get-ChildItem -LiteralPath qa -Recurse -File -Filter "*.md" |
        Where-Object { $_.BaseName -match "^[GFSETP]\d{2}b?_" }
    if ($skillDocs.Count -ne 45) {
        Add-Failure "Expected 45 Skill documents, found $($skillDocs.Count)."
    }

    $indexChecks = @(
        @{ Path = "README.md"; Pattern = "45.*Skill" },
        @{ Path = "README.md"; Pattern = "24.*Skill" },
        @{ Path = "README.md"; Pattern = "14" },
        @{ Path = "qa/README.md"; Pattern = "45.*Skill" },
        @{ Path = if ($qaOverview) { $qaOverview.FullName } else { "" }; Pattern = "45.*Skill" },
        @{ Path = if ($qaSummary) { $qaSummary.FullName } else { "" }; Pattern = "45.*Skill" },
        @{ Path = if ($toolIndex) { $toolIndex.FullName } else { "" }; Pattern = "T10_" }
    )

    foreach ($check in $indexChecks) {
        if (-not $check.Path -or -not (Test-Path -LiteralPath $check.Path)) {
            continue
        }
        $content = Get-Content -Raw -Encoding utf8 -LiteralPath $check.Path
        if ($content -notmatch $check.Pattern) {
            Add-Failure "Index pattern '$($check.Pattern)' is missing from $($check.Path)."
        }
    }

    if ($t08) {
        $t08Content = Get-Content -Raw -Encoding utf8 -LiteralPath $t08.FullName
        $routedPaths = [regex]::Matches($t08Content, '(?:01_|02_)[^|\r\n]+\.md') |
            ForEach-Object { $_.Value.Trim() } |
            Sort-Object -Unique
        if ($routedPaths.Count -ne 24) {
            Add-Failure "Expected 24 routed domain Skills in T08, found $($routedPaths.Count)."
        }
        if ($t08Content -match '(?m)^-{3,}\|') {
            Add-Failure "T08 contains a malformed Markdown table separator."
        }
        if (([regex]::Matches($t08Content, 'Excel.*does not need|Excel.*need not|Excel.*no need')).Count -gt 1) {
            Add-Failure "T08 contains duplicate Excel input rules."
        }
    }

    $platformSkills = @(
        "generate-testcase",
        "testcase-xmind-format",
        "openspec-propose",
        "openspec-apply-change",
        "openspec-explore",
        "openspec-archive-change"
    )

    foreach ($skill in $platformSkills) {
        $claudePath = ".claude/skills/$skill/SKILL.md"
        $geminiPath = ".gemini/skills/$skill/SKILL.md"
        $codexPath = ".codex/skills/$skill/SKILL.md"
        $codexUiPath = ".codex/skills/$skill/agents/openai.yaml"

        Test-SkillFrontmatter -Path $claudePath -ExpectedName $skill
        Test-SkillFrontmatter -Path $geminiPath -ExpectedName $skill
        Test-SkillFrontmatter -Path $codexPath -ExpectedName $skill

        if ((Test-Path -LiteralPath $claudePath) -and (Test-Path -LiteralPath $geminiPath)) {
            $claudeHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $claudePath).Hash
            $geminiHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $geminiPath).Hash
            if ($claudeHash -ne $geminiHash) {
                Add-Failure "Claude/Gemini Skill copies differ: $skill"
            }
        }

        if (-not (Test-Path -LiteralPath $codexUiPath -PathType Leaf)) {
            Add-Failure "Missing Codex UI metadata: $codexUiPath"
        }
        else {
            $ui = Get-Content -Raw -Encoding utf8 -LiteralPath $codexUiPath
            $skillReference = '$' + $skill
            if (-not $ui.Contains('Use ' + $skillReference)) {
                Add-Failure "Codex default prompt does not reference ${skillReference}: $codexUiPath"
            }
        }
    }

    $xmindFormat = Get-Content -Raw -Encoding utf8 -LiteralPath ".claude/skills/testcase-xmind-format/SKILL.md"
    if (-not $xmindFormat.Contains('TC-006')) {
        Add-Failure "Detailed XMind format does not show different conditions as separate TCs."
    }

    foreach ($legacyRootArtifact in @("proposal.md", "design.md", "tasks.md")) {
        if (Test-Path -LiteralPath (Join-Path "openspec" $legacyRootArtifact)) {
            Add-Failure "OpenSpec artifact must live under a named change: openspec/$legacyRootArtifact"
        }
    }

    foreach ($path in @(
        "openspec/changes",
        "openspec/specs",
        "openspec/changes/rescue-scorpion",
        "openspec/changes/rescue-scorpion/specs"
    )) {
        if (-not (Test-Path -LiteralPath $path -PathType Container)) {
            Add-Failure "Missing OpenSpec directory: $path"
        }
    }

    $deltaSpecs = @(Get-ChildItem -LiteralPath "openspec/changes/rescue-scorpion/specs" -Recurse -File -Filter "spec.md" -ErrorAction SilentlyContinue)
    if ($deltaSpecs.Count -ne 5) {
        Add-Failure "Expected 5 Rescue Scorpion delta specs, found $($deltaSpecs.Count)."
    }

    $openSpecCommand = Get-Command openspec.cmd -ErrorAction SilentlyContinue
    if (-not $openSpecCommand) {
        $openSpecCommand = Get-Command openspec -ErrorAction SilentlyContinue
    }
    if (-not $openSpecCommand) {
        Add-Failure "OpenSpec CLI is not installed."
    }
    else {
        $null = & $openSpecCommand.Source list --json 2>&1
        if ($LASTEXITCODE -ne 0) {
            Add-Failure "OpenSpec list failed; the workspace is not initialized."
        }
        $null = & $openSpecCommand.Source validate --all --strict --no-interactive 2>&1
        if ($LASTEXITCODE -ne 0) {
            Add-Failure "OpenSpec strict validation failed."
        }
    }

    $manifestPath = "testcases/README.md"
    if (Test-Path -LiteralPath $manifestPath) {
        $manifest = Get-Content -Raw -Encoding utf8 -LiteralPath $manifestPath
        $artifactRows = [regex]::Matches(
            $manifest,
            '(?m)^\|\s*`([^`]+)`\s*\|\s*([^|]+)\|\s*(candidate|final|draft|intermediate|legacy)\s*\|\s*([^|]+)\|'
        )

        $registeredNames = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
        foreach ($row in $artifactRows) {
            $name = $row.Groups[1].Value
            $format = $row.Groups[2].Value.Trim()
            $status = $row.Groups[3].Value
            $related = $row.Groups[4].Value
            $null = $registeredNames.Add($name)
            $artifactPath = Join-Path "testcases" $name

            if (-not (Test-Path -LiteralPath $artifactPath -PathType Leaf)) {
                Add-Failure "Manifest references a missing testcase artifact: $name"
                continue
            }

            $relatedMatch = [regex]::Match($related, '`([^`]+\.xmind)`')
            if ($relatedMatch.Success) {
                $relatedName = $relatedMatch.Groups[1].Value
                $null = $registeredNames.Add($relatedName)
                $relatedPath = Join-Path "testcases" $relatedName
                if (-not (Test-Path -LiteralPath $relatedPath -PathType Leaf)) {
                    Add-Failure "Manifest references a missing XMind artifact: $relatedName"
                }
                elseif ($status -in @("candidate", "final")) {
                    Test-XMindArchive -Path $relatedPath
                }
            }

            if ($status -notin @("candidate", "final")) {
                continue
            }

            $artifactContent = Get-Content -Raw -Encoding utf8 -LiteralPath $artifactPath
            if ($format -match 'T10 smoke') {
                $points = ([regex]::Matches($artifactContent, '(?m)^-\s+[^\r\n]+$')).Count
                $leaves = ([regex]::Matches($artifactContent, '(?m)^\s{4}-\s+[SAB]\s*$')).Count
                if ($points -eq 0 -or $points -ne $leaves) {
                    Add-Failure "T10 candidate must have one S/A/B leaf per test point: $name"
                }
                if ($artifactContent -match '(?m)^-\s+TC-' -or $artifactContent -match '(?m)^\s{8,}-\s+') {
                    Add-Failure "T10 candidate contains detailed testcase nodes: $name"
                }
            }
            elseif ($format -match 'Detailed TC') {
                $tc = ([regex]::Matches($artifactContent, '(?m)^-\s+TC-[^\r\n]+$')).Count
                $steps = ([regex]::Matches($artifactContent, '(?m)^\s{4}-\s+[^\r\n]+$')).Count
                $expected = ([regex]::Matches($artifactContent, '(?m)^\s{8}-\s+[^\r\n]+$')).Count
                $priority = ([regex]::Matches($artifactContent, '(?m)^\s{12}-\s+.*P[012]\s*$')).Count
                if ($tc -eq 0 -or $steps -ne $expected -or $expected -ne $priority) {
                    Add-Failure "Detailed candidate has inconsistent TC/step/expected/priority structure: $name"
                }
            }
        }

        Get-ChildItem -LiteralPath testcases -File |
            Where-Object { $_.Name -ne "README.md" } |
            ForEach-Object {
                if (-not $registeredNames.Contains($_.Name)) {
                    Add-Failure "Testcase artifact is not registered in the manifest: $($_.Name)"
                }
            }
    }

    $markdownRoots = @(
        "README.md",
        "qa",
        ".claude",
        ".gemini",
        ".codex",
        "openspec",
        "examples",
        "testcases"
    )
    if ($standardPath) {
        $markdownRoots += $standardPath
    }

    $markdownFiles = foreach ($path in $markdownRoots) {
        if (Test-Path -LiteralPath $path -PathType Leaf) {
            Get-Item -LiteralPath $path
        }
        elseif (Test-Path -LiteralPath $path -PathType Container) {
            Get-ChildItem -LiteralPath $path -Recurse -File -Filter "*.md"
        }
    }

    foreach ($file in $markdownFiles | Sort-Object FullName -Unique) {
        $content = Get-Content -Raw -Encoding utf8 -LiteralPath $file.FullName
        foreach ($match in [regex]::Matches($content, "\[[^\]]+\]\(([^)]+)\)")) {
            $link = $match.Groups[1].Value.Split("#")[0]
            if (-not $link -or $link -match "^(https?|mailto):") {
                continue
            }

            $decodedLink = [uri]::UnescapeDataString($link)
            $target = Join-Path $file.DirectoryName $decodedLink
            if (-not (Test-Path -LiteralPath $target)) {
                $relativeFile = $file.FullName.Substring($repoRoot.Length + 1)
                Add-Failure "Broken local Markdown link in ${relativeFile}: $link"
            }
        }
    }

    if ($failures.Count -gt 0) {
        Write-Host "Repository validation failed:" -ForegroundColor Red
        foreach ($failure in $failures) {
            Write-Host "- $failure" -ForegroundColor Red
        }
        exit 1
    }

    Write-Host "Repository validation passed: Skills, routes, OpenSpec, testcase manifest, XMind archives, and links are consistent." -ForegroundColor Green
}
finally {
    Pop-Location
}
