extends StaticBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _on_boss_cutscene_end_cutscene() -> void:
	collision_shape_2d.disabled = true
