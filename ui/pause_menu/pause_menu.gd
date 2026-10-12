extends CanvasLayer

func _ready() -> void:
	self.hide()
	resume()

func _process(delta: float) -> void:
	pressedEscape()

func resume():
	get_tree().paused = false
	self.hide()
	
func pause():
	get_tree().paused = true
	self.show()

func pressedEscape():
	if Input.is_action_just_pressed("escape") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused:
		resume()

func _on_resume_button_pressed() -> void:
	resume()

func _on_restart_button_pressed() -> void:
	resume()
	SceneTransition.reload_scene()

func _on_options_button_pressed() -> void:
	pass

func _on_quit_to_main_menu_button_pressed() -> void:
	resume()
	SceneTransition.change_scene("res://ui/main_menu/main_menu.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
