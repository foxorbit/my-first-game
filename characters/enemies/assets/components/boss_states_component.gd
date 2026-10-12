extends Node
class_name BossStateComponent

@export var character: CharacterBody2D
@onready var character_collision_shape: CollisionShape2D = $"../../CharacterCollisionShape"
@onready var enemy_health_component: EnemyHealthComponent = $"../EnemyHealthComponent"
@onready var hurt_box_shape: CollisionShape2D = $"../../HurtBox/HurtBoxShape"
@onready var jump: AudioStreamPlayer2D = $"../../Sounds/Jump"
@onready var jump_2: AudioStreamPlayer2D = $"../../Sounds/Jump2"
@onready var slam: AudioStreamPlayer2D = $"../../Sounds/Slam"
var player_target: CharacterBody2D

@onready var hover_timer: Timer = $HoverTimer
@onready var stomp_timer: Timer = $StompTimer

signal change_state(current_state)

var can_stomp = true
var can_be_stunned = true

enum STATE {
	STANDING,
	HOVER,
	STUNNED,
	STOMP_ANTICIPATION,
	STOMPING,
}

var active_state := STATE.STANDING

func _ready() -> void:
	switch_state(STATE.STANDING)

func _physics_process(delta: float) -> void:
	match active_state:
		STATE.STANDING:
			pass
		STATE.HOVER:
			character.position.y = move_toward(character.position.y, player_target.position.y - 500, 1000 * delta)
			character.position.x = move_toward(character.position.x, player_target.position.x, 1000 * delta)
		STATE.STUNNED:
			if not character.is_on_floor():
				character.velocity += character.get_gravity() * delta
		STATE.STOMP_ANTICIPATION:
			character.position.y = move_toward(character.position.y, character.position.y - 10, 1000 * delta)
		STATE.STOMPING:
			character.velocity.y += 10000 * delta
			if character.is_on_floor():
				switch_state(STATE.STUNNED)
	character.move_and_slide()
	
func switch_state(to_state: STATE) -> void:
	var previous_state := active_state
	active_state = to_state
	change_state.emit(active_state)

	match active_state:
		STATE.STANDING:
			hurt_box_shape.set_deferred("disabled", true)
		STATE.HOVER:
			jump.play()
			can_stomp = true
			can_be_stunned = true
			hover_timer.start()
			hurt_box_shape.set_deferred("disabled", true)
		STATE.STUNNED:
			hurt_box_shape.set_deferred("disabled", false)
		STATE.STOMP_ANTICIPATION:
			stomp_timer.start()
			jump_2.play()
		STATE.STOMPING:
			slam.play()

func _on_boss_fight_trigger_start_boss_fight(body: CharacterBody2D) -> void:
	player_target = body
	switch_state(STATE.HOVER)

func _on_hover_timer_timeout() -> void:
	if can_stomp:
		can_stomp = false
		switch_state(STATE.STOMP_ANTICIPATION)

func _on_stomp_timer_timeout() -> void:
	if can_be_stunned:
		can_be_stunned = false
		switch_state(STATE.STOMPING)

func _on_enemy_health_component_health_decreased(amount: int) -> void:
	switch_state(STATE.HOVER)
