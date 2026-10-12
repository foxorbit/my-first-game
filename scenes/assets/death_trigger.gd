class_name DeathTrigger
extends Area2D

@export var damage := 1000

@export var hitbox: CollisionShape2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(hurtbox: PlayerHurtBox) -> void:
	if hitbox == null:
		return
	print("Instakill")
	hurtbox.health_component.damage(damage)
	
