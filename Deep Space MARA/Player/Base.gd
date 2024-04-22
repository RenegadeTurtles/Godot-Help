extends State

class_name Base

@export var baseSpeed := 15.5
@export var baseGroundAccel: float = 1.0125
@export var baseGroundDecel: float = 1.0125
#@export var baseAirDecel: float = 0.473

@export var player: CharacterBody3D
@onready var spring_arm: SpringArm3D = %CameraSpring

var velocity: Vector3


func enter():
	print("Player is moving!")
	player = get_tree().get_first_node_in_group("Player")
	
func state_physics_update(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var move_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (
		player.transform.basis * Vector3(
			move_dir.x, 0, move_dir.y).rotated(
				Vector3.UP, spring_arm.rotation.y).normalized())
	var adjustment: Vector3


	if direction:
		velocity.x = move_toward(
			velocity.x, direction.x * baseSpeed, baseGroundAccel)
		velocity.z = move_toward(
			velocity.z, direction.z * baseSpeed, baseGroundAccel)
	else:
		velocity.x = move_toward(
			velocity.x, 0.0, baseGroundDecel)
		velocity.z = move_toward(
			velocity.z, 0.0, baseGroundDecel)

	adjustment.x = direction.x - velocity.dot(
		player.get_floor_normal())
	adjustment.z = direction.z - velocity.dot(
		player.get_floor_normal())
	adjustment = adjustment.limit_length(
		baseGroundAccel * delta)

	velocity += Vector3(adjustment.x, 0, adjustment.z)
	
	player.velocity.x = velocity.x
	player.velocity.z = velocity.z
	
	if Input.is_action_pressed("dash"):
		Transitioned.emit(self, "dash")
