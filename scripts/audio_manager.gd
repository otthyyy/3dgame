extends Node3D

@onready var footstep_player: AudioStreamPlayer3D = $FootstepPlayer
@onready var jump_player: AudioStreamPlayer3D = $JumpPlayer
@onready var landing_player: AudioStreamPlayer3D = $LandingPlayer
@onready var sprint_player: AudioStreamPlayer3D = $SprintPlayer

@export var footstep_interval: float = 0.4
@export var sprint_footstep_interval: float = 0.3

var footstep_timer: float = 0.0
var player_controller: CharacterBody3D = null
var was_on_floor: bool = false

func _ready() -> void:
    player_controller = get_parent() as CharacterBody3D
    if player_controller:
        if player_controller.has_signal("jumped"):
            player_controller.jumped.connect(_on_player_jumped)
        if player_controller.has_signal("sprint_started"):
            player_controller.sprint_started.connect(_on_sprint_started)
        if player_controller.has_signal("sprint_stopped"):
            player_controller.sprint_stopped.connect(_on_sprint_stopped)
        
    _setup_placeholder_audio()

func _physics_process(delta: float) -> void:
    if not player_controller:
        return
    
    var is_on_floor := player_controller.is_on_floor()
    
    if not was_on_floor and is_on_floor and player_controller.velocity.y < -2.0:
        _play_landing()
    
    was_on_floor = is_on_floor
    
    if is_on_floor:
        var velocity_xz := Vector2(player_controller.velocity.x, player_controller.velocity.z).length()
        if velocity_xz > 0.5:
            var is_sprinting := false
            if player_controller.has_method("is_sprinting_active"):
                is_sprinting = player_controller.is_sprinting_active()
            var interval := sprint_footstep_interval if is_sprinting else footstep_interval
            
            footstep_timer += delta
            if footstep_timer >= interval:
                _play_footstep()
                footstep_timer = 0.0
        else:
            footstep_timer = 0.0

func _setup_placeholder_audio() -> void:
    var players := [footstep_player, jump_player, landing_player, sprint_player]
    for player in players:
        if not player:
            continue
        var sine := AudioStreamSine.new()
        sine.frequency = 110.0
        sine.volume_db = -12.0
        player.stream = sine

func _play_sine_tone(audio_player: AudioStreamPlayer3D, frequency: float, duration: float, volume_db: float) -> void:
    if not audio_player:
        return
    var sine := audio_player.stream as AudioStreamSine
    if sine == null:
        return
    if audio_player.playing:
        audio_player.stop()
    sine.frequency = frequency
    sine.volume_db = volume_db
    audio_player.play()
    
    var timer := get_tree().create_timer(duration)
    timer.timeout.connect(func():
        if audio_player:
            audio_player.stop()
    )

func _play_footstep() -> void:
    if footstep_player:
        var frequency := randf_range(90.0, 120.0)
        _play_sine_tone(footstep_player, frequency, 0.12, -10.0)

func _play_landing() -> void:
    if landing_player:
        var frequency := randf_range(60.0, 80.0)
        _play_sine_tone(landing_player, frequency, 0.18, -8.0)

func _on_player_jumped() -> void:
    if jump_player:
        var frequency := randf_range(140.0, 160.0)
        _play_sine_tone(jump_player, frequency, 0.14, -9.0)

func _on_sprint_started() -> void:
    if sprint_player:
        _play_sine_tone(sprint_player, 55.0, 0.25, -14.0)

func _on_sprint_stopped() -> void:
    if sprint_player:
        sprint_player.stop()
