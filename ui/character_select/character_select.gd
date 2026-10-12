extends CanvasLayer

var dash_cube := preload("res://characters/players/assets/dash_cube.tscn")
var slide_cube := preload("res://characters/players/assets/slide_cube.tscn")
var stomp_cube := preload("res://characters/players/assets/stomp_cube.tscn")

signal cube_selected(node)

func _ready() -> void:
	self.visible = true

func _on_dash_cube_button_pressed() -> void:
	spawn_selected_cube(dash_cube)

func _on_slide_cube_button_pressed() -> void:
	spawn_selected_cube(slide_cube)

func _on_stomp_cube_button_pressed() -> void:
	spawn_selected_cube(stomp_cube)
	
# I am quite happy with this function. I wanted an option to specify where the player spawns so I
# made a spawn point node. If it is missing the player will instead spawn at the world origin.
func spawn_selected_cube(selected_cube: PackedScene) -> void:
	var cube_instance := selected_cube.instantiate()
	if get_tree().current_scene.get_node("SpawnPoint"):
		cube_instance.position = get_tree().current_scene.get_node("SpawnPoint").global_position
	else:
		print("Could not find Spawn Point")
	get_tree().current_scene.add_child(cube_instance)
	cube_selected.emit(cube_instance)
