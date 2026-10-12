extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
signal start_boss_fight(body: CharacterBody2D)
	
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	start_boss_fight.emit(body)
	collision_shape_2d.set_deferred("disabled", true)
