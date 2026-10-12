class_name PlayerHitBox
extends Area2D

@export var damage := 1

signal successful_hit

@export var hitbox: CollisionShape2D
@export var movement_component: MovementComponent

func _ready() -> void:
	self.area_entered.connect(_on_area_entered)

func _on_movement_component_change_state(current_state: Variant) -> void:
	match current_state:
		6: hitbox.disabled = false
		7: hitbox.disabled = false
		8: hitbox.disabled = false
		_: hitbox.disabled = true

func _on_area_entered(hurtbox: EnemyHurtBox) -> void:
	if hitbox == null:
		return
	successful_hit.emit()
	hurtbox.enemy_health_component.damage(damage)
	hurtbox.owner.knockback(hurtbox.global_position - self.global_position)
	
	movement_component.call_deferred("knockback", self.global_position - hurtbox.global_position)
	
