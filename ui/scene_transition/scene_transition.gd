extends CanvasLayer

func change_scene(target: String) -> void:
	$AnimationPlayer.play_backwards("fade_in")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play("fade_in")
	
func reload_scene() -> void:
	$AnimationPlayer.play_backwards("fade_in")
	await $AnimationPlayer.animation_finished
	get_tree().reload_current_scene()
	$AnimationPlayer.play("fade_in")

func quit_game() -> void:
	$AnimationPlayer.play_backwards("fade_in")
	await $AnimationPlayer.animation_finished
	get_tree().quit()
