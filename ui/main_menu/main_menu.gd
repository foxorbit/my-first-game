extends Control

@onready var game_complete_sound: AudioStreamPlayer = $GameCompleteSound

func _ready() -> void:
	if Levels.level_1_completed == false:
		$Buttons/Level2.text = "LOCKED"
	if Levels.level_2_completed == false:
		$Buttons/Level3.text = "LOCKED"
	if Levels.level_3_completed == true:
		$DemoCompleteLabel.text = "GAME COMPLETED!"
		game_complete_sound.play()

func _on_level_1_pressed() -> void:
	SceneTransition.change_scene("res://scenes/levels/level_1.tscn")

func _on_level_2_pressed() -> void:
	if Levels.level_1_completed:
		SceneTransition.change_scene("res://scenes/levels/level_2.tscn")

func _on_level_3_pressed() -> void:
	if Levels.level_2_completed:
		SceneTransition.change_scene("res://scenes/levels/level_3.tscn")

func _on_quit_pressed() -> void:
	SceneTransition.quit_game()
