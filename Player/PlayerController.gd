extends KinematicBody

################-VARIABLES-###############

#PLAYER
#Variables
var gravity = -40
var velocity = Vector3()
var maxSpeed = 20
var direction = Vector3()

var canWallJump
onready var firstJump = true

onready var rightRaycast = get_node("RayCastLeft")
onready var leftRaycast = get_node("RayCastRight")

#Constants
const JUMP_SPEED = 18
const ACCELERATION = 5
const DECELERATION = 6
const MAX_SLOPE_ANGLE = 45

#CAMERA
#mouse rotation
onready var camera = $Head/Camera
onready var head = $Head
#mouse sens
var MOUSE_SENSITIVITY = 0.05

#LABELS
onready var speed = 0
onready var jump = 0
onready var isOnFloor = true

#JUMP TIMER
onready var jumpTimer = get_node("JumpTimer")

###########################################

func _physics_process(delta):
	Movement(delta)
	GUIVariables()

#everything about movement
func Movement(delta):
	
	var inputMovementVector = MovementInput()
	
	#direction
	direction = Vector3()
	var camXform = camera.get_global_transform()
	direction += -camXform.basis.z * inputMovementVector.y
	direction += camXform.basis.x * inputMovementVector.x

	#Jumping
	Jumping()
	
	#On floor lerp for smoother slowing down
	if is_on_floor():
		maxSpeed = lerp(maxSpeed, 20, DECELERATION * delta)

	#Restarting jump direction
	direction.y = 0

	#Normalizing movement
	direction = direction.normalized()

	#Adding gravity
	velocity.y += delta * gravity

	var hVelocity = velocity
	hVelocity.y = 0

	var target = direction
	target *= maxSpeed
	
	var acceleration
	if direction.dot(hVelocity) > 0:
		acceleration = ACCELERATION
	else:
		acceleration = DECELERATION

	#Interpolationg velocity and applying it to base velocity
	hVelocity = hVelocity.linear_interpolate(target, acceleration * delta)
	velocity.x = hVelocity.x
	velocity.z = hVelocity.z

	#Adding velocity to player
	velocity = move_and_slide(velocity, Vector3.UP, 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

#jumping mechanics (func called in Movement(delta))
func Jumping():

	if is_on_floor():
		if Input.is_action_just_pressed("move_jump"):
			firstJump = true
			canWallJump = false
			velocity.y = JUMP_SPEED
			maxSpeed += 4
	elif firstJump:
		canWallJump = true
		firstJump = false

	if canWallJump and Input.is_action_just_pressed("move_jump"):
		if rightRaycast.is_colliding() or leftRaycast.is_colliding():
			velocity.y = JUMP_SPEED + 8
			maxSpeed += 6
			canWallJump = false
			jumpTimer.start(.5)

#getting input for left and right
func MovementInput():
	var inputMovementVector = Vector2()

	if Input.is_action_pressed("move_forward"):
		inputMovementVector.y += 1
	if Input.is_action_pressed("move_backward"):
		inputMovementVector.y += -1
	if Input.is_action_pressed("move_left"):
		inputMovementVector.x += -1
	if Input.is_action_pressed("move_right"):
		inputMovementVector.x += 1
	
	return inputMovementVector

#changing GUI variables
func GUIVariables():
	#Variables for GUI labels
	speed = sqrt(velocity.z * velocity.z + velocity.x * velocity.x)
	jump = velocity.y
	isOnFloor = is_on_floor() or (canWallJump and (leftRaycast.is_colliding() or rightRaycast.is_colliding())) 

#Camera movement
func _input(event):

	#finding every mouse movement when mouse is captured
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:

		#Rotating HEAD up and down
		head.rotate_x(deg2rad(event.relative.y * -MOUSE_SENSITIVITY))
		#Rotating WHOLE BODY left and right
		self.rotate_y(deg2rad(event.relative.x * -MOUSE_SENSITIVITY))

		var cameraRotation = head.rotation_degrees
		#Clamping camera for up and down
		cameraRotation.x = clamp(cameraRotation.x, -70, 70)
		head.rotation_degrees = cameraRotation

func _on_JumpTimer_timeout():
	canWallJump = true
