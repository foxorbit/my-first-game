extends Node

@onready var wall_detection_ray_right: RayCast2D = $"../../RayCasts/WallDetectionRayRight"
@onready var ledge_detection_ray_right: RayCast2D = $"../../RayCasts/LedgeDetectionRayRight"
@onready var wall_detection_ray_left: RayCast2D = $"../../RayCasts/WallDetectionRayLeft"
@onready var ledge_detection_ray_left: RayCast2D = $"../../RayCasts/LedgeDetectionRayLeft"
@onready var jump: AudioStreamPlayer2D = $"../../Sounds/Jump"
@onready var wait_timer: Timer = $WaitTimer

@export var stats_component: Node

@export var character: CharacterBody2D
@export var direction := 1
@export var speed := 100
@export var chase_speed := 200
@export var gravity := 1500.0
var rng = RandomNumberGenerator.new()
var player_target: CharacterBody2D

signal change_state(current_state)
	
enum STATE {
	PATROL,
	CHASE,
	WAIT,
}

var active_state := STATE.PATROL

func _ready() -> void:
	change_state.emit(active_state)

func _physics_process(delta: float) -> void:
	match active_state:
		STATE.PATROL:
			if direction == 1:
				if _right_side():
					direction = direction * -1
			if direction == -1:
				if _left_side():
					direction = direction * -1

			character.velocity.x = move_toward(character.velocity.x, direction * speed, 500 * delta)
		STATE.CHASE:
			if player_target == null:
				pass
			var target_direction = player_target.global_position.x - character.global_position.x
			if target_direction > 1:
				direction = 1
			elif target_direction < -1:
				direction = -1
			else: direction = 0
			
			if direction == 1:
				if _right_side():
					_attempt_to_jump(character)
			if direction == -1:
				if _left_side():
					_attempt_to_jump(character)
			if direction == 0:
				_attempt_to_jump(character)

			character.velocity.x = move_toward(character.velocity.x, direction * chase_speed, 1000 * delta)
		STATE.WAIT:
			direction = 0

			character.velocity.x = move_toward(character.velocity.x, direction * speed, 500 * delta)

	character.velocity.y += gravity * delta
	character.move_and_slide()
	
func switch_state(to_state: STATE) -> void:
	# When the enemy dies it calls queue_free(). It appears the game sees it as
	# the player exiting the Area2D and the enemy will attempt to start its
	# wait timer even if the timer no longer exists. I tried some different
	# solutions like is_queued_for_deletion(), but it did not work. Moving the
	# nodes higher up in the scene tree did remove the error, but that felt like
	# a workaround.
	# My solution was to have a variable that tracks if the entity is alive.
	if not stats_component.is_alive:
		return
	var previous_state := active_state
	active_state = to_state
	change_state.emit(active_state)

	match active_state:
		STATE.PATROL:
			var random_direction = rng.randi_range(0,1)
			if random_direction == 0:
				direction = 1
			else:
				direction = -1
		STATE.CHASE:
			wait_timer.stop()
		STATE.WAIT:
			wait_timer.start()
			
func _attempt_to_jump(character: CharacterBody2D) -> void:
	if character.is_on_floor():
		jump.play()
		character.velocity.y = -500

func _left_side() -> bool:
	return wall_detection_ray_left.is_colliding() or !ledge_detection_ray_left.is_colliding()

func _right_side() -> bool:
	return wall_detection_ray_right.is_colliding() or !ledge_detection_ray_right.is_colliding()

func _on_player_detector_body_entered(body: Node2D) -> void:
	player_target = body
	switch_state(STATE.CHASE)

func _on_player_chase_radius_body_exited(body: Node2D) -> void:
	if active_state == STATE.CHASE:
		player_target = null
		switch_state(STATE.WAIT)

func _on_wait_timer_timeout() -> void:
	switch_state(STATE.PATROL)
