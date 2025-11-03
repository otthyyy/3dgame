# FPS Locomotion MVP

A first-person locomotion prototype featuring WASD movement, sprinting, jumping, and camera controls in a greybox test environment.

## 🎮 Controls

### Movement
- **W/A/S/D**: Move forward/left/backward/right
- **Left Shift (Hold)**: Sprint (increases speed by ~1.6x)
- **Space**: Jump
- **Mouse**: Look around (camera rotation)

### Menu
- **Esc**: Pause menu

## 📊 Features

### Core Mechanics
- **Walking**: Base speed of 4.5 m/s with smooth acceleration/deceleration
- **Sprinting**: Enhanced speed of 7.2 m/s when holding Shift while moving
- **Jumping**: Single jump with coyote time (125ms) and input buffering (100ms)
- **Camera**: First-person view with configurable FOV (70-110°) and optional head-bob
- **Collision**: Capsule-based character controller with step climbing (0.3m)
- **Slope Handling**: Maximum climbable angle of 45°

### Advanced Systems
- **Coyote Time**: Jump grace period when leaving platform edges (100-150ms)
- **Jump Buffer**: Pre-input jump commands within 80-120ms window
- **Air Control**: Limited mid-air movement with 40% control factor
- **FOV Kick**: Dynamic FOV increase during sprint (+3°)
- **Head Bob**: Subtle camera movement tied to velocity (can be disabled)

### Greybox Test Level
The test arena includes:
- **Ground Platform**: 40x40m main play area
- **Various Height Platforms**: Testing 1m and 1.5m jumps
- **Ramps**: Multiple angles for testing slope mechanics
- **Narrow Corridor**: Testing confined space navigation
- **Open Area**: Testing sprint and camera feel
- **Cylinder Obstacle**: Testing collision and navigation
- **Upper Deck**: High platform with ramp access
- **Checkpoint System**: Respawn points for testing

### UI/UX
- **Minimal Crosshair**: Center screen reference
- **FPS Counter**: Real-time performance monitoring (top-left)
- **Sprint Indicator**: Visual feedback when sprinting
- **Pause Menu** with:
  - Mouse Sensitivity adjustment (0.1 - 1.0)
  - FOV slider (70° - 110°)
  - Invert Y axis toggle
  - Head bob toggle
  - Master volume control
  - Resume and Quit options

### Audio
- **Footsteps**: Adaptive to movement speed (faster during sprint)
- **Jump Sound**: With pitch variation
- **Landing Sound**: When falling and hitting ground
- **Sprint Whoosh**: Ambient sound during sprint

### Telemetry (Optional)
The game tracks and exports telemetry data to JSON on quit:
- Total sprint time
- Distance traveled
- Number of jumps performed
- Session duration

Telemetry files are saved to: `user://telemetry/telemetry_[timestamp].json`

## ⚙️ Tuning Parameters

### Movement
| Parameter | Default Value | Description |
|-----------|---------------|-------------|
| Walk Speed | 4.5 m/s | Base movement speed |
| Sprint Speed | 7.2 m/s | Speed when holding Shift |
| Walk Acceleration | 12 m/s² | Ground acceleration rate |
| Walk Deceleration | 16 m/s² | Ground stopping rate |
| Sprint Acceleration | 18 m/s² | Sprint acceleration boost |
| Air Acceleration | 6 m/s² | Acceleration while airborne |
| Air Control | 0.4 (40%) | Movement control in air |
| Friction | 16 m/s² | Ground friction force |

### Jump
| Parameter | Default Value | Description |
|-----------|---------------|-------------|
| Jump Impulse | 4.5 m/s | Initial upward velocity (~1m height) |
| Gravity | 20 m/s² | Downward acceleration |
| Coyote Time | 125 ms | Grace period for edge jumps |
| Jump Buffer | 100 ms | Pre-input window |

### Camera
| Parameter | Default Value | Description |
|-----------|---------------|-------------|
| Mouse Sensitivity | 0.3 | Default look sensitivity |
| Pitch Clamp | ±85° | Vertical look limit |
| Base FOV | 90° | Field of view |
| FOV Sprint Kick | +3° | FOV increase during sprint |
| FOV Smoothing | 8.0 | FOV transition speed |
| Head Bob Amplitude | 0.05 | Head bob intensity |
| Head Bob Frequency | 2.0 | Head bob speed |

### Collision
| Parameter | Default Value | Description |
|-----------|---------------|-------------|
| Capsule Radius | 0.4 m | Character collision radius |
| Capsule Height | 1.8 m | Character collision height |
| Max Slope Angle | 45° | Maximum climbable slope |
| Step Height | 0.3 m | Auto-climb step threshold |
| Floor Snap | 0.4 m | Ground detection distance |

## 🚀 Getting Started

### Prerequisites
- Godot Engine 4.2 or later

### Running the Game
1. Open the project in Godot Engine
2. Press F5 or click the "Play" button
3. Use WASD to move, Shift to sprint, Space to jump
4. Press Esc to access the pause menu

### Building
1. Open Project → Export
2. Configure Windows export preset (if not present)
3. Export Project to generate .exe

## 📁 Project Structure

```
├── scenes/
│   ├── main.tscn                 # Main game scene
│   ├── player/
│   │   └── player.tscn          # Player character
│   └── environment/
│       └── greybox_level.tscn   # Test level
├── scripts/
│   ├── game_state.gd            # Global game state manager
│   ├── player_controller.gd     # Player movement logic
│   ├── audio_manager.gd         # Audio playback system
│   ├── telemetry.gd             # Data tracking
│   └── checkpoint.gd            # Checkpoint trigger
├── ui/
│   ├── hud.gd                   # HUD overlay
│   └── pause_menu.gd            # Pause menu logic
├── docs/
│   └── tuning_parameters.md     # Detailed parameter documentation
├── project.godot                # Godot project configuration
└── README.md                    # This file
```

## 🎯 QA Checklist

- ✅ WASD responds without perceptible input lag
- ✅ No sliding at rest (proper friction)
- ✅ Sprint activates with Shift and deactivates on release
- ✅ No overshoot when stopping sprint
- ✅ Jump works at platform edges (coyote time)
- ✅ Jump buffer captures pre-inputs
- ✅ Solid collisions with no clipping through geometry
- ✅ Step offset allows climbing small steps
- ✅ Camera pitch clamps correctly (±85°)
- ✅ No camera jitter on slopes
- ✅ Pause menu captures mouse and restores on resume
- ✅ Slope limit prevents climbing steep surfaces
- ✅ FPS counter displays real-time performance
- ✅ Telemetry exports on quit

## 🎮 Performance Targets

- **Resolution**: 1920x1080 (configurable)
- **Target FPS**: 60+ FPS
- **Platform**: Windows PC
- **Startup Time**: < 10 seconds
- **Frame Time Variance**: < 2ms

## 🔧 Configuration

All game settings can be adjusted at runtime via the pause menu (Esc):
- Mouse sensitivity
- Field of view
- Y-axis inversion
- Head bob toggle
- Master volume

## 📝 Development Timeline

| Phase | Duration | Tasks |
|-------|----------|-------|
| Day 1-3 | 2-3 days | Setup, input, controller, camera, greybox |
| Day 4-7 | 3-4 days | Sprint, acceleration tuning, jump mechanics |
| Day 8-10 | 2-3 days | UI, HUD, audio implementation |
| Day 11-13 | 2-3 days | Stabilization, bug fixes, telemetry |
| Day 14-15 | 1-2 days | Build, README, QA pass |

## 🔮 Post-MVP Features (Nice-to-Have)

- Key rebinding system
- Multiple surface types with different sounds/materials
- Crouch mechanic
- Slide mechanic during sprint
- Console platform support
- Automated movement tests
- Stamina system for sprint
- Double jump ability
- Wall running

## 📄 License

This is a prototype/MVP project for demonstration purposes.

## 🐛 Known Issues

None currently. Please report any issues discovered during testing.

---

**Version**: 1.0.0  
**Engine**: Godot 4.2+  
**Last Updated**: 2024
