## ADDED Requirements

### Requirement: Sequential stage progression
The system SHALL unlock the next stage only after every task reward in the current stage has been claimed.

#### Scenario: Current stage still has an unclaimed reward
- **WHEN** at least one current-stage task is incomplete or claimable but unclaimed
- **THEN** the next stage remains locked

#### Scenario: All current-stage rewards are claimed
- **WHEN** every task in the current stage is in the claimed state
- **THEN** the next stage unlocks and the interface refreshes to its task list

### Requirement: Final reward delivery
The system SHALL automatically deliver the grand reward exactly once after all stages are complete.

#### Scenario: Final stage completes
- **WHEN** the player claims the final outstanding stage-task reward
- **THEN** the grand reward is credited once and the hero showcase is opened when the reward contains a hero

#### Scenario: Completion response is repeated
- **WHEN** the client repeats or replays the final completion request
- **THEN** the server returns the existing completion state without delivering another grand reward
