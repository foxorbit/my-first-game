extends Label

func _on_movement_component_change_state(current_state: Variant) -> void:
	match current_state:
		0: self.text = "FLOOR"
		1: self.text = "JUMP"
		2: self.text = "FALL"
		3: self.text = "CROUCH"
		4: self.text = "WALL SLIDE"
		5: self.text = "WALL JUMP"
		6: self.text = "DASH"
		7: self.text = "SLIDE"
		8: self.text = "STOMP"
		9: self.text = "CUTSCENE"
		_: self.text = "UNKNOWN"
