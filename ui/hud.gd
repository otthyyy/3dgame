extends Control

@onready var fps_label: Label = $FPSCounter
@onready var sprint_indicator: ColorRect = $SprintIndicator
@onready var crosshair: Control = $Crosshair

var player: CharacterBody3D = null

func _ready() -> void:
	if sprint_indicator:
		sprint_indicator.visible = false
	
	var player_node := get_tree().get_first_node_in_group("player")
	if player_node:
		player = player_node as CharacterBody3D
		if player and player.has_signal("sprint_started"):
			player.sprint_started.connect(_on_sprint_started)
		if player and player.has_signal("sprint_stopped"):
			player.sprint_stopped.connect(_on_sprint_stopped)

func _process(_delta: float) -> void:
	if fps_label:
		var fps := Engine.get_frames_per_second()
		fps_label.text = "FPS: %d" % fps
		
		if fps >= 60:
			fps_label.modulate = Color.GREEN
		elif fps >= 30:
			fps_label.modulate = Color.YELLOW
		else:
			fps_label.modulate = Color.RED

func _on_sprint_started() -> void:
	if sprint_indicator:
		sprint_indicator.visible = true

func _on_sprint_stopped() -> void:
	if sprint_indicator:
		sprint_indicator.visible = false
