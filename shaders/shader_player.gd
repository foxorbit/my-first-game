extends AnimationPlayer

func _on_health_component_health_decreased(amount: int) -> void:
	self.play("hit_flash")

func _on_health_component_health_increased(amount: int) -> void:
	self.play("heal_flash")
	
func _on_player_playcritanimation() -> void:
	self.play("crit_flash")
