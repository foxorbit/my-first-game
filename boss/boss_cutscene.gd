extends Node

@export var cutscene_marker: Marker2D

signal cutscene(cutscene_marker: Marker2D)
signal reveal_boss_health
signal end_cutscene

func _on_boss_cutscene_trigger_start_boss_cutscene() -> void:
	cutscene.emit(cutscene_marker)
	await get_tree().create_timer(5.0).timeout
	reveal_boss_health.emit()
	await get_tree().create_timer(2.0).timeout
	end_cutscene.emit()
