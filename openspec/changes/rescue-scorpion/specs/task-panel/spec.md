## ADDED Requirements

### Requirement: Rescue Scorpion entry placement
The task panel SHALL reserve a stable entry area above the existing task list for Rescue Scorpion.

#### Scenario: Feature entry is visible
- **WHEN** Rescue Scorpion is unlocked and the player opens the main interface
- **THEN** the entry appears above the task panel without covering or resizing task interactions incorrectly

#### Scenario: Feature entry is hidden
- **WHEN** Rescue Scorpion is not unlocked or its switch is disabled
- **THEN** the task panel uses its normal layout without an empty interactive entry
