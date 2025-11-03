extends Node

signal pause_changed(paused: bool)
signal mouse_sensitivity_changed(value: float)
signal invert_y_changed(enabled: bool)
signal fov_changed(value: float)
signal head_bob_changed(enabled: bool)
signal master_volume_changed(value: float)
signal quit_requested

var paused: bool = false
var mouse_sensitivity: float = 0.3
var invert_y: bool = false
var base_fov: float = 90.0
var head_bob_enabled: bool = true
var master_volume: float = 0.8

const SENSITIVITY_RANGE := Vector2(0.1, 1.0)
const FOV_RANGE := Vector2(70.0, 110.0)
const VOLUME_RANGE := Vector2(0.0, 1.0)

func _ready() -> void:
    set_process_input(true)
    process_mode = Node.PROCESS_MODE_ALWAYS
    _update_master_volume()

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("pause"):
        toggle_pause()

func set_mouse_sensitivity(value: float) -> void:
    mouse_sensitivity = clamp(value, SENSITIVITY_RANGE.x, SENSITIVITY_RANGE.y)
    emit_signal("mouse_sensitivity_changed", mouse_sensitivity)

func set_invert_y(enabled: bool) -> void:
    invert_y = enabled
    emit_signal("invert_y_changed", invert_y)

func set_base_fov(value: float) -> void:
    base_fov = clamp(value, FOV_RANGE.x, FOV_RANGE.y)
    emit_signal("fov_changed", base_fov)

func set_head_bob_enabled(enabled: bool) -> void:
    head_bob_enabled = enabled
    emit_signal("head_bob_changed", head_bob_enabled)

func set_master_volume(value: float) -> void:
    master_volume = clamp(value, VOLUME_RANGE.x, VOLUME_RANGE.y)
    _update_master_volume()
    emit_signal("master_volume_changed", master_volume)

func toggle_pause() -> void:
    set_pause_state(not paused)

func set_pause_state(value: bool) -> void:
    if paused == value:
        return
    paused = value
    get_tree().paused = paused
    if paused:
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    else:
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    emit_signal("pause_changed", paused)

func request_quit() -> void:
    emit_signal("quit_requested")
    get_tree().quit()

func _update_master_volume() -> void:
    var clamped_volume: float = clamp(master_volume, VOLUME_RANGE.x, VOLUME_RANGE.y)
    var db_value: float = lerp(-40.0, 0.0, clamped_volume)
    var master_bus_index: int = AudioServer.get_bus_index("Master")
    AudioServer.set_bus_volume_db(master_bus_index, db_value)
