## ADDED Requirements

### Requirement: Rescue Scorpion red-dot aggregation
The red-dot system SHALL aggregate all claimable Rescue Scorpion task rewards to the feature entry without changing existing red-dot behavior.

#### Scenario: At least one task reward is claimable
- **WHEN** any Rescue Scorpion task changes to the claimable state
- **THEN** its task red dot and the aggregated entry red dot are visible

#### Scenario: No task reward remains claimable
- **WHEN** all Rescue Scorpion task rewards are incomplete or already claimed
- **THEN** the task and entry red dots are cleared
