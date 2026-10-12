class_name EnemyHurtBox
extends Area2D

@export var enemy_health_component: EnemyHealthComponent

@export var hurtbox: CollisionShape2D

func _on_enemy_health_component_died() -> void:
	hurtbox.set_deferred("disabled", true)
