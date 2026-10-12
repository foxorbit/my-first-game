extends Control
class_name BossHealthBar

@export var health_component: EnemyHealthComponent
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var health_bar: ProgressBar = $CanvasLayer/HealthBar
@onready var damage_indicator: ProgressBar = $CanvasLayer/HealthBar/DamageIndicator
@onready var indicator_timer: Timer = $CanvasLayer/HealthBar/IndicatorTimer
@onready var name_label: Label = $CanvasLayer/NameLabel

func _ready() -> void:
	health_bar.max_value = health_component.max_health
	health_bar.value = health_component.max_health
	damage_indicator.max_value = health_bar.max_value
	damage_indicator.value = health_bar.value
	
	health_component.health_changed.connect(_on_enemy_health_component_health_changed)
	canvas_layer.hide()

func _on_enemy_health_component_health_changed(current_health: int, max_health: int) -> void:
	health_bar.value = current_health
	indicator_timer.start()

func _on_indicator_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(damage_indicator, "value", health_bar.value, 0.5).set_trans(tween.TRANS_LINEAR)

func _on_boss_cutscene_reveal_boss_health() -> void:
	canvas_layer.show()
	var tween = create_tween()
	health_bar.value = 0
	tween.tween_property(health_bar, "value", health_bar.max_value, 5).set_trans(tween.TRANS_LINEAR)
