extends CharacterBody3D

@export_group("Movement Parameters")
@export var walk_speed: float = 4.5
@export var sprint_speed: float = 7.2
@export var walk_acceleration: float = 12.0
@export var walk_deceleration: float = 16.0
@export var sprint_acceleration: float = 18.0
@export var air_acceleration: float = 6.0
@export var air_control: float = 0.4
@export var friction: float = 16.0

@export_group("Jump Parameters")
@export var jump_impulse: float = 4.5
@export var gravity: float = 20.0
@export var coyote_time: float = 0.125
@export var jump_buffer_time: float = 0.1
@export var hard_landing_velocity_threshold: float = 10.0

@export_group("Camera Parameters")
@export var mouse_sensitivity: float = 0.3
@export var pitch_clamp: Vector2 = Vector2(-85.0, 85.0)
@export var head_bob_amplitude: float = 0.05
@export var head_bob_frequency: float = 2.0
@export var fov_sprint_kick: float = 3.0
@export var fov_smoothing: float = 8.0

@export_group("Slope Parameters")
@export var max_slope_angle: float = 45.0
@export var step_height: float = 0.3

@onready var camera: Camera3D = $CameraMount/Camera3D
@onready var camera_mount: Node3D = $CameraMount

var pitch: float = 0.0
var yaw: float = 0.0

var is_sprinting: bool = false
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var time_since_grounded: float = 0.0
var head_bob_time: float = 0.0
var base_camera_pos: Vector3
var respawn_transform: Transform3D
@export var fall_respawn_height: float = -15.0
var head_bob_enabled: bool = true
var was_on_floor: bool = false
var landing_state_initialized: bool = false

var telemetry := {
    "sprint_time": 0.0,
    "distance_traveled": 0.0,
    "jumps_performed": 0,
    "session_start": 0.0
}
var previous_position: Vector3

signal jumped
signal landed(was_hard_landing: bool)
signal sprint_started
signal sprint_stopped

func _ready() -> void:
    if camera_mount:
        base_camera_pos = camera.position
    if camera:
        camera.fov = GameState.base_fov
    
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    
    GameState.mouse_sensitivity_changed.connect(_on_mouse_sensitivity_changed)
    GameState.fov_changed.connect(_on_fov_changed)
    GameState.head_bob_changed.connect(_on_head_bob_changed)
    
    floor_snap_length = step_height
    floor_max_angle = deg_to_rad(max_slope_angle)
    
    telemetry.session_start = Time.get_unix_time_from_system()
    respawn_transform = global_transform
    previous_position = global_position
    mouse_sensitivity = GameState.mouse_sensitivity
    head_bob_enabled = GameState.head_bob_enabled
    was_on_floor = is_on_floor()

func _input(event: InputEvent) -> void:
    if GameState.paused:
        return
    
    if event is InputEventMouseMotion:
        _handle_mouse_look(event.relative)

func _physics_process(delta: float) -> void:
    if GameState.paused:
        return
    
    var was_on_floor_before := was_on_floor
    
    _update_grounding(delta)
    _handle_jump_input(delta)
    _handle_movement(delta)
    _update_camera(delta)
    
    var vertical_velocity_before_move := velocity.y
    move_and_slide()
    
    var is_on_floor_now := is_on_floor()
    if landing_state_initialized and not was_on_floor_before and is_on_floor_now:
        var impact_speed := abs(vertical_velocity_before_move) if vertical_velocity_before_move < 0.0 else 0.0
        var was_hard_landing := impact_speed > hard_landing_velocity_threshold
        emit_signal("landed", was_hard_landing)
    
    was_on_floor = is_on_floor_now
    landing_state_initialized = true
    
    if global_position.y < fall_respawn_height:
        respawn()
    
    var distance_this_frame := global_position.distance_to(previous_position)
    telemetry.distance_traveled += distance_this_frame
    Telemetry.register_distance(distance_this_frame)
    previous_position = global_position

func _handle_mouse_look(relative: Vector2) -> void:
    var sensitivity := mouse_sensitivity * 0.001
    yaw -= relative.x * sensitivity
    
    var pitch_delta := -relative.y * sensitivity
    if GameState.invert_y:
        pitch_delta = -pitch_delta
    pitch += pitch_delta
    pitch = clamp(pitch, deg_to_rad(pitch_clamp.x), deg_to_rad(pitch_clamp.y))
    
    rotation.y = yaw
    camera_mount.rotation.x = pitch

func _handle_movement(delta: float) -> void:
    var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    
    var previous_sprint_state := is_sprinting
    var wants_to_sprint := Input.is_action_pressed("sprint") and direction.length() > 0.1 and is_on_floor()
    is_sprinting = wants_to_sprint
    
    if is_sprinting:
        telemetry.sprint_time += delta
        Telemetry.register_sprint_time(delta)
    
    if previous_sprint_state != is_sprinting:
        if is_sprinting:
            emit_signal("sprint_started")
        else:
            emit_signal("sprint_stopped")
    
    var target_speed := sprint_speed if is_sprinting else walk_speed
    var current_acceleration := sprint_acceleration if is_sprinting else walk_acceleration
    
    var horizontal_velocity := velocity
    horizontal_velocity.y = 0.0
    
    if direction.length() > 0.0:
        var target_velocity := direction * target_speed
        var accel := current_acceleration if is_on_floor() else air_acceleration
        var control_factor := 1.0 if is_on_floor() else air_control
        target_velocity *= control_factor if not is_on_floor() else 1.0
        horizontal_velocity = horizontal_velocity.move_toward(target_velocity, accel * delta)
    else:
        if is_on_floor():
            horizontal_velocity = horizontal_velocity.move_toward(Vector3.ZERO, friction * delta)
    
    velocity.x = horizontal_velocity.x
    velocity.z = horizontal_velocity.z
    velocity.y -= gravity * delta
    
    if is_on_floor():
        var floor_normal := get_floor_normal()
        var floor_angle := rad_to_deg(acos(floor_normal.dot(Vector3.UP)))
        if floor_angle > max_slope_angle:
            velocity += floor_normal * -5.0

func _update_grounding(delta: float) -> void:
    if is_on_floor():
        coyote_timer = coyote_time
        time_since_grounded = 0.0
    else:
        coyote_timer -= delta
        time_since_grounded += delta

func _handle_jump_input(delta: float) -> void:
    if Input.is_action_just_pressed("jump"):
        jump_buffer_timer = jump_buffer_time
    
    if jump_buffer_timer > 0:
        jump_buffer_timer -= delta
        
        if coyote_timer > 0 and time_since_grounded < coyote_time:
            _perform_jump()
            jump_buffer_timer = 0
            coyote_timer = 0

func _perform_jump() -> void:
    velocity.y = jump_impulse
    telemetry.jumps_performed += 1
    Telemetry.register_jump()
    emit_signal("jumped")

func _update_camera(delta: float) -> void:
    if not camera:
        return
    
    var target_fov := GameState.base_fov
    if is_sprinting:
        target_fov += fov_sprint_kick
    
    camera.fov = lerp(camera.fov, target_fov, fov_smoothing * delta)
    
    if head_bob_enabled and is_on_floor():
        var velocity_xz := Vector2(velocity.x, velocity.z).length()
        if velocity_xz > 0.5:
            head_bob_time += delta * head_bob_frequency * (velocity_xz / walk_speed)
            var bob_offset_y := sin(head_bob_time) * head_bob_amplitude
            var bob_offset_x := cos(head_bob_time * 0.5) * head_bob_amplitude * 0.5
            camera.position = base_camera_pos + Vector3(bob_offset_x, bob_offset_y, 0)
        else:
            head_bob_time = 0
            camera.position = lerp(camera.position, base_camera_pos, delta * 10.0)
    else:
        camera.position = lerp(camera.position, base_camera_pos, delta * 10.0)

func _on_mouse_sensitivity_changed(value: float) -> void:
    mouse_sensitivity = value

func _on_fov_changed(value: float) -> void:
    if camera:
        camera.fov = value

func _on_head_bob_changed(enabled: bool) -> void:
    head_bob_enabled = enabled

func get_telemetry() -> Dictionary:
    telemetry["session_duration"] = Time.get_unix_time_from_system() - telemetry.session_start
    return telemetry.duplicate()

func export_telemetry_json(path: String) -> void:
    var file := FileAccess.open(path, FileAccess.WRITE)
    if file:
        file.store_string(JSON.stringify(get_telemetry(), "\t"))
        file.close()
        print("Telemetry exported to: ", path)

func respawn() -> void:
    global_transform = respawn_transform
    velocity = Vector3.ZERO
    pitch = 0.0
    yaw = 0.0
    previous_position = global_position
    was_on_floor = false
    landing_state_initialized = false

func set_checkpoint(checkpoint_transform: Transform3D) -> void:
    respawn_transform = checkpoint_transform

func is_sprinting_active() -> bool:
    return is_sprinting
