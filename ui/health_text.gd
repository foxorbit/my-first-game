extends Label

func _on_health_component_health_changed(current_health: int, max_health: int) -> void:
	self.text = str("%d/%d" % [current_health,max_health])
