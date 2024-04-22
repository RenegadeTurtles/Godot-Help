extends State

class_name Idle

@export var player: CharacterBody3D

	
func enter():
	print("Player is idle!")

func state_update(_delta: float) -> void:
	pass
	
func state_physics_update(_delta: float) -> void:
	if Input.get_vector("left", "right", "forward", "back"):
		Transitioned.emit(self, "base")
