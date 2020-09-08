extends Control

var isVisible = false

func _ready():
	hide()
	$Settings.hide()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if !isVisible:
			show()
			isVisible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			hide()
			$Settings.hide()
			isVisible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://Scenes/MainMenu/MainMenu.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_SettingsButton_pressed():
	$Settings.show()
