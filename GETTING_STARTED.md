# Getting Started

This guide will help you run and build the FPS Locomotion MVP.

## Requirements

- **Godot Engine 4.2** or later
  - Download from: https://godotengine.org/download
  - Recommended: Godot 4.2 or 4.3 stable
- **Operating System**: Windows, Linux, or macOS (for development)
- **Target Platform**: Windows PC (for final build)

## Opening the Project

1. **Download/Clone** this repository
2. **Launch Godot Engine 4.2+**
3. Click **"Import"** in the Project Manager
4. Navigate to the project folder and select `project.godot`
5. Click **"Import & Edit"**

The project will open in the Godot editor.

## Running the Game

### Method 1: Quick Run (F5)
- Press **F5** or click the **Play** button in the top-right
- The game will start at the main scene

### Method 2: Run from Scene
- Open `scenes/main.tscn` in the editor
- Press **F6** or click **Play Scene**

## Controls Reference

| Input | Action |
|-------|--------|
| **W** | Move forward |
| **A** | Strafe left |
| **S** | Move backward |
| **D** | Strafe right |
| **Left Shift** (hold) | Sprint |
| **Space** | Jump |
| **Mouse** | Look around |
| **Esc** | Pause menu |

## Testing Checklist

When playtesting, verify:
- [ ] Movement feels responsive with WASD
- [ ] Sprint activates with Shift (indicator shows)
- [ ] Jump works, including at platform edges
- [ ] Camera rotates smoothly with mouse
- [ ] Pause menu opens with Esc
- [ ] FPS counter shows 60+ FPS
- [ ] Can adjust settings in pause menu
- [ ] Collisions work (no falling through floor)

## Building the Game

### Windows Build

1. **Open Export Settings**
   - Click **Project → Export...**
   
2. **Add Windows Preset** (if not present)
   - Click **"Add..."**
   - Select **"Windows Desktop"**
   
3. **Configure Export**
   - Set executable name (e.g., `FPSLocomotionMVP.exe`)
   - Enable **"Export With Debug"** for testing
   - Disable for final release build
   
4. **Export Project**
   - Click **"Export Project..."**
   - Choose destination folder
   - Click **"Save"**

5. **Test the Build**
   - Navigate to the export folder
   - Run the `.exe` file
   - Verify all features work

### Build Checklist
- [ ] Game starts without errors
- [ ] Controls work correctly
- [ ] Performance is 60+ FPS
- [ ] Audio plays correctly
- [ ] Pause menu functions
- [ ] Telemetry exports on quit

## Troubleshooting

### Game Won't Start
- Ensure Godot 4.2+ is installed
- Check console for error messages
- Verify `project.godot` exists in root folder

### Low Performance
- Check GPU drivers are up to date
- Reduce resolution in `project.godot` (window/size)
- Lower MSAA quality (rendering/anti_aliasing/quality)

### Mouse Not Captured
- Click inside the game window
- If stuck, press **Esc** to open pause menu
- Resume to re-capture mouse

### Audio Not Playing
- Check volume slider in pause menu
- Ensure audio drivers are functional
- Audio uses procedurally-generated tones (no external files required)

### Telemetry Not Exporting
- Check `user://` directory location:
  - Windows: `%APPDATA%\Godot\app_userdata\[project_name]\`
  - Linux: `~/.local/share/godot/app_userdata/[project_name]/`
  - macOS: `~/Library/Application Support/Godot/app_userdata/[project_name]/`
- Look for `telemetry/` subfolder

## Development Tips

### Adjusting Player Parameters
1. Open `scenes/player/player.tscn`
2. Select the root `Player` node
3. Inspect the **exported variables** in the Inspector panel
4. Adjust values like:
   - Walk Speed
   - Sprint Speed
   - Jump Impulse
   - Gravity
   - Mouse Sensitivity
   - etc.

### Modifying the Level
1. Open `scenes/environment/greybox_level.tscn`
2. Add/modify StaticBody3D nodes for geometry
3. Each platform needs:
   - MeshInstance3D for visual
   - CollisionShape3D for physics

### Adding New Input Actions
1. Open **Project → Project Settings → Input Map**
2. Add new action name
3. Assign key/button
4. Reference in scripts with `Input.is_action_pressed("action_name")`

## Next Steps

After testing the MVP, consider:
- Review `docs/QA_CHECKLIST.md` for thorough testing
- Check `docs/tuning_parameters.md` for value adjustments
- Experiment with different movement speeds/jump heights
- Test on different hardware configurations

## Resources

- **Godot Documentation**: https://docs.godotengine.org/en/stable/
- **Project Structure**: See `README.md`
- **Tuning Guide**: See `docs/tuning_parameters.md`
- **QA Checklist**: See `docs/QA_CHECKLIST.md`

---

For issues or questions, refer to the main README.md or check the Godot community forums.
