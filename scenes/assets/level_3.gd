extends Node2D

func _on_goal_body_entered(body: Node2D) -> void:
	Levels.level_3_completed = true
	SceneTransition.change_scene("res://ui/main_menu/main_menu.tscn")
