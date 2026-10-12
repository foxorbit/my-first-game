class_name Player
extends CharacterBody2D

signal playcritanimation

@export var movement_component: MovementComponent
@export var health_component: HealthComponent
@export var knockback_strength := 1

func _ready() -> void:
	health_component.died.connect(_on_died)

func _physics_process(delta: float) -> void:
	pass
	# Testing
	#if Input.is_action_just_pressed("hurt"):
	#	health_component.damage(1)
	#if Input.is_action_just_pressed("heal"):
	#	health_component.heal(1)
	#if Input.is_action_just_pressed("crit_test"):
	#	playcritanimation.emit()
	
func _on_died() -> void:
	self.queue_free()
	
func knockback(knockback_direction: Vector2) -> void:
	velocity += knockback_direction * knockback_strength
