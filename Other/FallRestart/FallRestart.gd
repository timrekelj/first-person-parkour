extends Area

# Just a code for restarting a level when falling
func _on_FallRestart_body_entered(body):
	get_tree().reload_current_scene()
