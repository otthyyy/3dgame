extends Area3D

@export var respawn_offset: Vector3 = Vector3.ZERO

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and body.has_method("set_checkpoint"):
		var checkpoint_transform := global_transform
		checkpoint_transform.origin += respawn_offset
		body.set_checkpoint(checkpoint_transform)
		print("Checkpoint reached!")
