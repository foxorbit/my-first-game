extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("close")

func _on_boss_cube_boss_died() -> void:
	animation_player.play("open")
