extends Control

func _ready():
	pass

func _on_PlaygroundButton_pressed():
	get_tree().change_scene("res://Scenes/Playground/Playground.tscn")

func _on_LevelSelectButton_pressed():
	get_tree().change_scene("res://Scenes/LevelSelect/LevelSelect.tscn")

func _on_SettingsButton_pressed():
	get_tree().change_scene("res://Scenes/Settings/Settings.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
