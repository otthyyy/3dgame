extends Node3D

@onready var footstep_player: AudioStreamPlayer3D = $FootstepPlayer
@onready var jump_player: AudioStreamPlayer3D = $JumpPlayer
@onready var landing_player: AudioStreamPlayer3D = $LandingPlayer
@onready var sprint_player: AudioStreamPlayer3D = $SprintPlayer

@export var footstep_interval: float = 0.4
@export var sprint_footstep_interval: float = 0.3

var footstep_timer: float = 0.0
var player_controller: CharacterBody3D = null

func _ready() -> void:
    player_controller = get_parent() as CharacterBody3D
    if player_controller:
        if player_controller.has_signal("jumped"):
            player_controller.jumped.connect(_on_player_jumped)
        if player_controller.has_signal("landed"):
            player_controller.landed.connect(_on_player_landed)
        if player_controller.has_signal("sprint_started"):
            player_controller.sprint_started.connect(_on_sprint_started)
        if player_controller.has_signal("sprint_stopped"):
            player_controller.sprint_stopped.connect(_on_sprint_stopped)
        
    _setup_placeholder_audio()

func _physics_process(delta: float) -> void:
    if not player_controller:
        return
    
    if player_controller.is_on_floor():
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
    else:
        footstep_timer = 0.0

func _setup_placeholder_audio() -> void:
    var players := [footstep_player, jump_player, landing_player, sprint_player]
    for player in players:
        if not player:
            continue
        var generator := AudioStreamGenerator.new()
        generator.mix_rate = 44100.0
        generator.buffer_length = 1.0
        player.stream = generator

func _play_sine_tone(audio_player: AudioStreamPlayer3D, frequency: float, duration: float, volume_db: float) -> void:
    if not audio_player:
        return
    
    var generator := audio_player.stream as AudioStreamGenerator
    if generator == null:
        return
    
    audio_player.stop()
    audio_player.volume_db = 0.0
    audio_player.play()
    
    var playback := audio_player.get_stream_playback() as AudioStreamGeneratorPlayback
    if playback == null:
        return
    
    playback.clear_buffer()
    
    var sample_rate := generator.mix_rate
    if sample_rate <= 0.0:
        sample_rate = AudioServer.get_mix_rate()
    
    var frames_to_fill := int(sample_rate * duration)
    if frames_to_fill <= 0:
        return
    
    var amplitude := db_to_linear(volume_db)
    var increment := TAU * frequency / sample_rate
    var phase := 0.0
    
    var frames_available := playback.get_frames_available()
    var frames_to_push := min(frames_to_fill, frames_available)
    for _i in range(frames_to_push):
        var sample_value := sin(phase) * amplitude
        playback.push_frame(Vector2(sample_value, sample_value))
        phase += increment
        if phase >= TAU:
            phase -= TAU

    if frames_to_push < frames_to_fill and frames_available < frames_to_fill:
        push_warning("Audio buffer underrun while generating tone")
    
    var timer := get_tree().create_timer(duration)
    timer.timeout.connect(func():
        if audio_player:
            audio_player.stop()
    )

func _play_footstep() -> void:
    if footstep_player:
        var frequency := randf_range(90.0, 120.0)
        _play_sine_tone(footstep_player, frequency, 0.12, -10.0)

func _on_player_landed(was_hard_landing: bool) -> void:
    if landing_player:
        var frequency := randf_range(60.0, 80.0)
        var volume := -8.0 if not was_hard_landing else -6.0
        _play_sine_tone(landing_player, frequency, 0.18, volume)

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
