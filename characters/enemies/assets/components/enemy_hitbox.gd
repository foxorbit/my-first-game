class_name EnemyHitBox
extends Area2D

@export var damage := 1
@export var can_knockback := true
#var toggle = true

@export var hitbox: CollisionShape2D

func _ready() -> void:
	self.area_entered.connect(_on_area_entered)

#func _physics_process(delta: float) -> void:
#	if Input.is_action_just_pressed("test_enemy_damage"):
#		if toggle:
#			hitbox.disabled = false
#			toggle = false
#		else:
#			hitbox.disabled = true
#			toggle = true

func _on_area_entered(hurtbox: PlayerHurtBox) -> void:
	if hitbox == null:
		return
	hurtbox.health_component.damage(damage)
	
	if can_knockback:
		hurtbox.owner.movement_component.call_deferred("knockback", hurtbox.global_position - self.global_position)
		self.owner.knockback(self.global_position - hurtbox.global_position)
	
func _on_enemy_health_component_died() -> void:
	hitbox.set_deferred("disabled", true)
