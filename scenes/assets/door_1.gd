extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("open")

func _on_boss_fight_trigger_start_boss_fight(body: CharacterBody2D) -> void:
	animation_player.play("close")
