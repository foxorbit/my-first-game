extends Node

@export var is_alive := true

func _on_enemy_health_component_died(node: CharacterBody2D) -> void:
	is_alive = false
