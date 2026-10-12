extends Camera2D

var player_cube = null
var temp_player
var temp_smoothing

func _on_character_select_cube_selected(player_node: CharacterBody2D) -> void:
	player_cube = player_node

func _physics_process(delta: float) -> void:
	if player_cube != null:
		self.position = player_cube.position

func _on_boss_cutscene_cutscene(cutscene_marker: Marker2D) -> void:
	temp_player = player_cube
	temp_smoothing = self.position_smoothing_speed
	self.position_smoothing_speed = 2
	player_cube = cutscene_marker

func _on_boss_cutscene_end_cutscene() -> void:
	self.position_smoothing_speed = temp_smoothing
	player_cube = temp_player
