extends Node2D

@onready var enemy_death: AudioStreamPlayer2D = $EnemyDeath
@onready var player_death: AudioStreamPlayer2D = $PlayerDeath

var player

func _on_character_select_cube_selected(node: Variant) -> void:
	node.health_component.died.connect(_player_died)
	player = node

func _player_died() -> void:
	player_death.global_position = player.global_position
	player_death.play()

func _on_enemy_health_component_died(node: CharacterBody2D) -> void:
	enemy_death.global_position = node.global_position
	enemy_death.play()
