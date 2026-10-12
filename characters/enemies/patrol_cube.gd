extends CharacterBody2D

@export var enemy_health_component: EnemyHealthComponent
@export var knockback_strength := 1

func _ready() -> void:
	enemy_health_component.died.connect(_on_died)

func knockback(knockback_direction: Vector2) -> void:
	velocity += knockback_direction * knockback_strength

func _on_died(node: CharacterBody2D) -> void:
	self.queue_free()
