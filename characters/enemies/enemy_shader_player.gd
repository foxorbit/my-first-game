extends AnimationPlayer

func _on_enemy_health_component_health_decreased(amount: int) -> void:
	self.play("hit_flash")

func _on_enemy_health_component_health_increased(amount: int) -> void:
	self.play("heal_flash")
