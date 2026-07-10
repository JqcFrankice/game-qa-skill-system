## ADDED Requirements

### Requirement: Entry unlock and visibility
The system SHALL show the Rescue Scorpion entry above the task panel only after the configured unlock condition is satisfied.

#### Scenario: Unlock after defeating Tiger Vanguard
- **WHEN** the player defeats Tiger Vanguard and the function switch is enabled
- **THEN** the Rescue Scorpion entry becomes visible above the task panel

#### Scenario: Entry remains unavailable before unlock
- **WHEN** the player has not defeated Tiger Vanguard
- **THEN** the Rescue Scorpion entry is hidden or rejects entry without creating activity progress

### Requirement: Entry countdown display
The entry SHALL display the remaining time for the current stage and refresh from the authoritative stage start time.

#### Scenario: Countdown refreshes while entry is visible
- **WHEN** the current stage is active and the player remains on the main interface
- **THEN** the entry countdown decreases continuously and does not increase because of client clock changes
