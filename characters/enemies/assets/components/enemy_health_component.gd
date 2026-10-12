extends Node
class_name EnemyHealthComponent

signal health_changed(current_health: int, max_health: int)
signal health_increased(amount: int)
signal health_decreased(amount: int)
signal died(node: CharacterBody2D)

@export var character: CharacterBody2D
@export var max_health := 1
@export var current_health := 0
@onready var hit: AudioStreamPlayer2D = $"../../Sounds/Hit"

func _ready() -> void:
	current_health = max_health
	emit_health_changed()
	
func damage(amount: int) -> void:
	var old_health = current_health
	current_health = clamp(current_health - amount, 0, max_health)
	if old_health == current_health:
		return
	hit.play()
	health_decreased.emit(amount)
	emit_health_changed()
	if current_health <= 0.0:
		died.emit(character)
	
func heal(amount: int) -> void:
	var old_health = current_health
	current_health = clamp(current_health + amount, 0, max_health)
	if old_health == current_health:
		return
	health_increased.emit(amount)
	emit_health_changed()

func emit_health_changed() -> void:
	health_changed.emit(current_health, max_health)
	#print("HP: %d / %s" % [current_health, max_health])
