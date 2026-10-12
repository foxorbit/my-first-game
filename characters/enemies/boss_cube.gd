extends CharacterBody2D

@export var enemy_health_component: EnemyHealthComponent
@onready var boss_state_component: BossStateComponent = $Components/BossStateComponent
@export var knockback_strength := 1
@onready var angry: AudioStreamPlayer2D = $Sounds/Angry
@onready var face: Label = $Face

signal boss_died

func _ready() -> void:
	enemy_health_component.died.connect(_on_died)

func knockback(knockback_direction: Vector2) -> void:
	velocity += knockback_direction * knockback_strength
	
func _on_died(node: CharacterBody2D) -> void:
	boss_died.emit()
	self.queue_free()

func _on_boss_cutscene_cutscene(cutscene_marker: Marker2D) -> void:
	await get_tree().create_timer(3.0).timeout
	angry.play()
	face.visible = true
