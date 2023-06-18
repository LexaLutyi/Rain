extends RigidBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -50.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
# var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var start_position: Vector2
var wind: Vector2 = Vector2(0, 0)
var dim:int = 3

func size():
	return 5 * mass ** (1. / dim)

func _ready():
	start_position = position


func _physics_process(delta):
	var error_position = position - start_position
	var error_velocity = linear_velocity
	var error_rotation = rotation
	var error_angular_velocity = angular_velocity

	var control = -200 * error_position - 100 * error_velocity
	var torque = -2 * error_rotation - 1 * error_angular_velocity
	if torque != 0:
		print(rotation, " ", angular_velocity, " ", torque)
	apply_central_force(control + wind * size())
	apply_torque(torque)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right") * Vector2(1, 0)
	if direction:
		apply_central_force(direction * SPEED)
