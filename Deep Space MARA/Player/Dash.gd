extends State

class_name Dash

@export var dashSpeed := 28.0
@export var dashGroundAccel: float = 0.675
@export var dashGroundDecel: float = 0.675
#@export var dashAirDecel: float = 0.158

@export var player: CharacterBody3D
@onready var spring_arm: SpringArm3D = %CameraSpring

var velocity: Vector3


func enter():
	print("DASH!!!")
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
			velocity.x, direction.x * dashSpeed, dashGroundAccel)
		velocity.z = move_toward(
			velocity.z, direction.z * dashSpeed, dashGroundAccel)
	else:
		velocity.x = move_toward(
			velocity.x, 0.0, dashGroundDecel)
		velocity.z = move_toward(
			velocity.z, 0.0, dashGroundDecel)

	adjustment.x = direction.x - velocity.dot(
		player.get_floor_normal())
	adjustment.z = direction.z - velocity.dot(
		player.get_floor_normal())
	adjustment = adjustment.limit_length(
		dashGroundAccel * delta)

	velocity += Vector3(adjustment.x, 0, adjustment.z)
	
	player.velocity.x = velocity.x
	player.velocity.z = velocity.z
	
	if Input.is_action_just_released("dash"):
		Transitioned.emit(self, "base")
