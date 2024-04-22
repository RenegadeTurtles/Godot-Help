extends Node

class_name State

signal Transitioned

func enter() -> void:
	pass

func exit() -> void:
	pass

func state_update(_delta: float) -> void:
	pass
	
func state_physics_update(_delta: float) -> void:
	pass
