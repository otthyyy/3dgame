# Tuning Parameters

This document lists the tuning parameters used throughout the FPS locomotion MVP. Values can be adjusted in the editor via exported variables on the `Player` scene or at runtime through the pause menu (Esc).

## Player Movement

| Parameter | Default | Description | Location |
|-----------|---------|-------------|----------|
| Walk Speed | 4.5 m/s | Base horizontal speed | Player → `walk_speed` |
| Sprint Speed | 7.2 m/s | Maximum sprint speed | Player → `sprint_speed` |
| Walk Acceleration | 12 m/s² | Acceleration when walking | Player → `walk_acceleration` |
| Sprint Acceleration | 18 m/s² | Acceleration when sprinting | Player → `sprint_acceleration` |
| Walk Deceleration | 16 m/s² | Deceleration when stopping | Player → `walk_deceleration` |
| Air Acceleration | 6 m/s² | Acceleration mid-air | Player → `air_acceleration` |
| Air Control | 0.4 | Relative air control factor | Player → `air_control` |
| Friction | 16 m/s² | Ground friction | Player → `friction` |

## Jumping

| Parameter | Default | Description | Location |
|-----------|---------|-------------|----------|
| Jump Impulse | 4.5 m/s | Initial upward velocity (~1 m height) | Player → `jump_impulse` |
| Gravity | 20 m/s² | Downward acceleration | Player → `gravity` |
| Coyote Time | 0.125 s | Grace window after leaving ground | Player → `coyote_time` |
| Jump Buffer | 0.1 s | Input buffer window before landing | Player → `jump_buffer_time` |

## Camera

| Parameter | Default | Description | Location |
|-----------|---------|-------------|----------|
| Mouse Sensitivity | 0.3 | Default look sensitivity | GameState (runtime adjustable) |
| Pitch Clamp | ±85° | Vertical look limit | Player → `pitch_clamp` |
| Head Bob Amplitude | 0.05 | Camera bob intensity | Player → `head_bob_amplitude` |
| Head Bob Frequency | 2.0 | Camera bob speed | Player → `head_bob_frequency` |
| FOV | 90° | Base field of view | GameState / Pause menu |
| FOV Sprint Kick | +3° | FOV increase while sprinting | Player → `fov_sprint_kick` |
| FOV Smoothing | 8.0 | FOV transition lerp speed | Player → `fov_smoothing` |

## Collision & Grounding

| Parameter | Default | Description | Location |
|-----------|---------|-------------|----------|
| Capsule Radius | 0.4 m | Character collision radius | Player → `CharacterBody3D` collision |
| Capsule Height | 1.8 m | Collision height | Player → `CharacterBody3D` collision |
| Step Height | 0.3 m | Auto-climb step offset | Player → `step_height` |
| Floor Snap | 0.4 m | Ground snapping distance | Player → `floor_snap_length` |
| Max Slope Angle | 45° | Maximum traversable slope | Player → `max_slope_angle` |

## Audio

| Parameter | Default | Description | Location |
|-----------|---------|-------------|----------|
| Footstep Interval | 0.4 s | Time between footsteps when walking | AudioManager → `footstep_interval` |
| Sprint Footstep Interval | 0.3 s | Time between footsteps when sprinting | AudioManager → `sprint_footstep_interval` |

## Telemetry

| Metric | Description |
|--------|-------------|
| Sprint Time | Total time spent sprinting |
| Distance Traveled | Total distance covered |
| Jumps | Number of jumps performed |
| Session Duration | Total playtime |

Telemetry files are stored in `user://telemetry/` with timestamps.
