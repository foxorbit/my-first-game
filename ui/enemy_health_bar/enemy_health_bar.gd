extends Control
class_name EnemyHealthBar

@export var health_component: EnemyHealthComponent
@onready var health_bar: ProgressBar = $HealthBar
@onready var damage_indicator: ProgressBar = $HealthBar/DamageIndicator
@onready var indicator_timer: Timer = $HealthBar/IndicatorTimer

func _ready() -> void:
	health_bar.max_value = health_component.max_health
	health_bar.value = health_component.max_health
	damage_indicator.max_value = health_bar.max_value
	damage_indicator.value = health_bar.value
	
	health_component.health_changed.connect(_on_enemy_health_component_health_changed)
	self.hide()

func _on_enemy_health_component_health_changed(current_health: int, max_health: int) -> void:
	self.show()
	health_bar.value = current_health
	indicator_timer.start()

func _on_indicator_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(damage_indicator, "value", health_bar.value, 0.5).set_trans(tween.TRANS_LINEAR)
