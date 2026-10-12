extends Control

var original_position: Vector2

func _ready() -> void:
	original_position = self.position
	var tween = create_tween()
	self.position = original_position + Vector2(-1000, 0)
	tween.tween_property(self, "position", original_position, 0.2)

func _on_character_select_cube_selected(node: Variant) -> void:
	original_position = self.position
	var tween = create_tween()
	tween.tween_property(self, "position", original_position + Vector2(-1000, 0), 0.1)
