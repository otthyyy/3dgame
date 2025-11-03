# QA Checklist – FPS Locomotion MVP

This document provides a comprehensive QA checklist for testing the FPS locomotion MVP.

## 🎮 Control Responsiveness

### WASD Movement
- [ ] **W key** moves player forward without input lag (< 50ms perceived)
- [ ] **A key** moves player left (strafing)
- [ ] **S key** moves player backward
- [ ] **D key** moves player right (strafing)
- [ ] Diagonal movement (W+A, W+D, S+A, S+D) works smoothly
- [ ] Movement direction is relative to camera facing direction
- [ ] Player stops immediately when keys are released (no sliding on flat ground)
- [ ] No "skating" or drifting when standing still

### Mouse Look
- [ ] Mouse movement rotates camera smoothly
- [ ] Horizontal rotation (yaw) is unlimited
- [ ] Vertical rotation (pitch) clamps at ±85°
- [ ] No camera jitter or stuttering during movement
- [ ] Camera rotation feels responsive (no lag)
- [ ] No gimbal lock or strange rotation behavior

### Sprint Mechanic
- [ ] Holding **Left Shift** while moving activates sprint
- [ ] Sprint increases movement speed noticeably (~1.6x)
- [ ] Sprint indicator appears in HUD when active
- [ ] Releasing Shift deactivates sprint immediately
- [ ] No overshoot or momentum issues when stopping sprint
- [ ] Sprint only works when moving forward or diagonally
- [ ] Sprint does not work when standing still
- [ ] Sprint does not work when only moving backward (S key)
- [ ] Sprint deactivates when player becomes airborne

### Jump Mechanic
- [ ] Pressing **Space** makes player jump
- [ ] Jump height is consistent (~1 meter)
- [ ] Cannot jump while already in the air (no double jump)
- [ ] Coyote time allows jump shortly after leaving platform edge (100-150ms)
- [ ] Jump buffer accepts jump input shortly before landing (80-120ms)
- [ ] Jump works reliably at platform edges
- [ ] Jump sound plays on takeoff
- [ ] Landing sound plays when falling and hitting ground

## 🏃 Movement Feel

### Acceleration & Deceleration
- [ ] Walking acceleration feels responsive (not instant, not sluggish)
- [ ] Sprint acceleration is faster than walk acceleration
- [ ] Deceleration when stopping is appropriately quick
- [ ] Air control is limited compared to ground control
- [ ] No jerky or robotic movement transitions

### Air Physics
- [ ] Gravity feels natural (not too floaty, not too heavy)
- [ ] Limited air control prevents mid-air maneuvering abuse
- [ ] Cannot "bunny hop" to gain speed unintentionally
- [ ] Fall speed accelerates naturally

### Slope Handling
- [ ] Can climb slopes up to 45° maximum angle
- [ ] Cannot walk up slopes steeper than 45°
- [ ] Sliding behavior on steep slopes feels natural
- [ ] No getting stuck on slope edges
- [ ] Movement speed not drastically affected on moderate slopes

## 🧱 Collision & Grounding

### Collision Detection
- [ ] Cannot walk through walls or obstacles
- [ ] No clipping through geometry when moving fast
- [ ] No getting stuck in corners or edges
- [ ] Collision feels solid (no penetration)
- [ ] Capsule collision shape works properly

### Step Climbing
- [ ] Can automatically climb steps up to 0.3m high
- [ ] Steps higher than 0.3m require jumping
- [ ] No getting stuck on small step geometry
- [ ] Step climbing feels smooth and natural

### Floor Snapping
- [ ] Player stays grounded on slopes
- [ ] No "hopping" when walking down stairs or slopes
- [ ] Floor detection works reliably

## 📹 Camera

### FOV
- [ ] Default FOV is 90° and feels appropriate
- [ ] FOV slider in pause menu works (70-110° range)
- [ ] FOV increases slightly during sprint (+3°)
- [ ] FOV transitions are smooth, not jarring
- [ ] No fish-eye or unnatural distortion

### Head Bob
- [ ] Head bob is subtle and tied to movement speed
- [ ] Head bob is more pronounced when sprinting
- [ ] Head bob stops when standing still
- [ ] Head bob can be disabled in pause menu
- [ ] When disabled, camera is stable

### Camera on Slopes
- [ ] No jitter when walking on slopes
- [ ] Camera pitch clamp prevents looking too far up/down
- [ ] Camera maintains orientation correctly on all geometry

## 🎨 Level Design (Greybox)

### Platform Variety
- [ ] Ground platform is large and stable
- [ ] Multiple platform heights exist (1m, 1.5m, 4.5m)
- [ ] Can reach platforms by jumping from ground (1-1.5m)
- [ ] Higher platforms require using ramps or other platforms

### Ramps
- [ ] Multiple ramps exist at different angles
- [ ] Ramps are within climbable angle limit
- [ ] No issues walking up and down ramps
- [ ] Sprint works properly on ramps

### Corridors & Open Areas
- [ ] Narrow corridor tests confined movement
- [ ] Open areas allow testing sprint and camera feel
- [ ] No invisible walls or unexpected collision

### Obstacles
- [ ] Central cylinder obstacle blocks movement correctly
- [ ] Can navigate around obstacles smoothly
- [ ] No getting stuck on cylindrical geometry

## 🎯 Checkpoint System

- [ ] Checkpoint trigger activates when player enters it
- [ ] Checkpoint saves respawn position
- [ ] Falling below Y=-15 triggers respawn
- [ ] Respawn places player at last checkpoint
- [ ] Velocity resets on respawn

## 🎵 Audio

### Footsteps
- [ ] Footstep sounds play when walking
- [ ] Footstep interval is faster when sprinting
- [ ] Footsteps stop when player is standing still or in air
- [ ] Pitch variation adds variety to footsteps

### Jump & Landing
- [ ] Jump sound plays when leaving ground
- [ ] Landing sound plays when hitting ground after fall
- [ ] Landing sound only plays on significant falls (velocity > 2 m/s)
- [ ] No landing sound on small hops

### Sprint
- [ ] Sprint whoosh/ambient sound plays when sprinting starts
- [ ] Sprint sound stops when sprint ends
- [ ] Sprint sound volume is appropriate (not too loud)

### Master Volume
- [ ] Master volume slider in pause menu affects all sounds
- [ ] Volume changes apply immediately
- [ ] At 0% volume, no sounds play
- [ ] At 100% volume, sounds are at full volume

## 🖥️ UI/UX

### HUD
- [ ] Minimal crosshair is visible and centered
- [ ] Crosshair does not obstruct view
- [ ] FPS counter displays in top-left
- [ ] FPS counter shows accurate real-time FPS
- [ ] FPS counter color changes based on performance:
  - Green: ≥60 FPS
  - Yellow: 30-59 FPS
  - Red: <30 FPS
- [ ] Sprint indicator appears when sprinting
- [ ] Sprint indicator hides when not sprinting

### Pause Menu
- [ ] **Esc** key opens pause menu
- [ ] Game pauses when menu is open
- [ ] Mouse becomes visible in pause menu
- [ ] **Resume** button closes menu and resumes game
- [ ] **Quit** button exits to desktop
- [ ] Mouse Sensitivity slider works (0.1-1.0)
  - Changes apply immediately
  - Value label updates
- [ ] Invert Y toggle works correctly
  - Vertical look direction inverts when enabled
- [ ] FOV slider works (70-110°)
  - Changes apply immediately
  - Value label updates
- [ ] Head Bob toggle works
  - Disabling stops head bob effect
- [ ] Master Volume slider works (0-100%)
  - Changes apply immediately
  - Value label updates

### Mouse Capture
- [ ] Mouse is captured (hidden, locked) during gameplay
- [ ] Mouse is released (visible, free) in pause menu
- [ ] Resuming game re-captures mouse
- [ ] No mouse cursor visible during normal gameplay

## ⚡ Performance

### Frame Rate
- [ ] Maintains ≥60 FPS at 1080p on target hardware
- [ ] No significant frame drops during normal play
- [ ] Frame time variance is < 2ms
- [ ] FPS counter consistently shows green (60+)

### Startup & Loading
- [ ] Game starts in < 10 seconds
- [ ] No loading screens during gameplay
- [ ] Scene is fully loaded before player control

### Stability
- [ ] No crashes during 15+ minutes of continuous play
- [ ] No memory leaks (consistent RAM usage)
- [ ] No error messages in console

## 📊 Telemetry

- [ ] Telemetry tracks sprint time
- [ ] Telemetry tracks distance traveled
- [ ] Telemetry tracks jumps performed
- [ ] Telemetry tracks session duration
- [ ] Telemetry exports to JSON on quit
- [ ] JSON file is valid and readable
- [ ] Telemetry data is accurate

## 🐛 Edge Cases

### Boundary Testing
- [ ] Cannot escape level bounds
- [ ] Fall respawn triggers correctly
- [ ] Respawn does not put player in invalid location

### Input Edge Cases
- [ ] Mashing jump repeatedly does not break jump
- [ ] Spamming sprint key does not cause issues
- [ ] Multiple simultaneous key presses handled correctly
- [ ] Pause during various actions works correctly

### Collision Edge Cases
- [ ] Landing on edge of platform works
- [ ] Jumping into ceiling/overhang stops upward velocity
- [ ] No getting stuck between two objects
- [ ] No phase-through on high-speed movement

## ✅ Final Acceptance

- [ ] All critical issues resolved
- [ ] All QA checklist items pass or have documented exceptions
- [ ] README is accurate and complete
- [ ] Build is playable end-to-end without softlocks
- [ ] Controls feel responsive and fun
- [ ] Performance meets 60 FPS target
- [ ] No crashes or critical bugs

---

**Tester**: _______________  
**Date**: _______________  
**Build Version**: _______________  
**Hardware**: _______________
