## ADDED Requirements

### Requirement: Authoritative stage timer
The system SHALL calculate the current-stage remaining time from the server-recorded `stage_start_time` and the configured duration.

#### Scenario: Client clock is changed
- **WHEN** the player changes the local device time while a stage is active
- **THEN** the displayed remaining time continues to follow server time

#### Scenario: Player reconnects before timeout
- **WHEN** the player reconnects before the current stage duration expires
- **THEN** the countdown resumes from the remaining server-authoritative duration

### Requirement: Timed-out stage restarts
The system SHALL restart the current stage timer when its duration expires without advancing to the next stage.

#### Scenario: Timer expires while online
- **WHEN** the current-stage countdown reaches zero
- **THEN** the same stage receives a new start time and its countdown restarts

#### Scenario: Timer expires while offline
- **WHEN** the player returns after the current-stage duration expired during the offline period
- **THEN** the same stage restarts with a new authoritative countdown
