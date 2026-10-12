extends Label

func _on_patrol_cube_movement_component_change_state(current_state: Variant) -> void:
	match current_state:
		0: self.text = "PATROL"
		1: self.text = "CHASE"
		2: self.text = "WAIT"
		_: self.text = "UNKNOWN"
