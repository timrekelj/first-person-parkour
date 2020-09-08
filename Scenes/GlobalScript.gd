extends Spatial

#Time variables
var timer
var time

func _ready():
	#Stops timer and set mouse on captured
	timer = 0
	time = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	#Open Bhop level when 2 is clicked
	if Input.is_action_just_pressed("GUI1"):
		get_tree().reload_current_scene()
	
	#Changing texts
	$GUI/Speed/Value.text = String(stepify(get_node("Player").get("speed"), 0.01))
	$GUI/Jump/Value.text = String(stepify(get_node("Player").get("jump"), 0.01))
	$GUI/Time/Value.text = String(stepify(timer, 0.01))
	
	#Changing color of isOnFloor rectangle based on if player can jump
	if (get_node("Player").get("isOnFloor")):
		$GUI/isOnFloor.color = Color(0,1,0,1)
	else:
		$GUI/isOnFloor.color = Color(1,0,0,1)

func _physics_process(delta):
	#Adding time to timer
	if time:
		timer += delta

#Signal for when you enter start area
func _on_StartArea_body_entered(body):
	timer = 0
	time = true
	
#Signal for when you enter end area
func _on_EndArea_body_entered(body):
	time = false
