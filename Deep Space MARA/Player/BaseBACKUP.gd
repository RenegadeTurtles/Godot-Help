extends State

#class_name Base

@export var baseSpeed := 15.5
@export var baseGroundAccel: float = 1.0125
@export var baseGroundDecel: float = 1.0125
#@export var baseAirDecel: float = 0.473

@export var mara_unit: CharacterBody3D
@onready var spring_arm: SpringArm3D = %CameraSpring

var velocity: Vector3


func state_physics_update(delta: float) -> void:
	print("Player is moving!")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var move_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (
		mara_unit.transform.basis * Vector3(
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
		mara_unit.get_floor_normal())
	adjustment.z = direction.z - velocity.dot(
		mara_unit.get_floor_normal())
	adjustment = adjustment.limit_length(
		baseGroundAccel * delta)

	velocity += Vector3(adjustment.x, 0, adjustment.z)
