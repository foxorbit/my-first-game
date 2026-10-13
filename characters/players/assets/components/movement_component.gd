extends Node
class_name MovementComponent

signal change_state(current_state)

# I will have to live with this code for the rest of this project.

@export var character: CharacterBody2D
@export var character_sprite: Sprite2D
@export var stats_component: StatsComponent

@onready var coyote_timer: Timer = %CoyoteTimer
@onready var dash_timer: Timer = %DashTimer
@onready var stomp_timer: Timer = %StompTimer
@onready var slide_timer: Timer = %SlideTimer
@onready var jump_buffer_timer: Timer = %JumpBufferTimer
@onready var jump: AudioStreamPlayer2D = $"../../Sounds/Jump"
@onready var dash: AudioStreamPlayer2D = $"../../Sounds/Dash"
@onready var slide: AudioStreamPlayer2D = $"../../Sounds/Slide"
@onready var stomp: AudioStreamPlayer2D = $"../../Sounds/Stomp"

enum STATE {
	FLOOR,
	JUMP,
	FALL,
	CROUCH,
	WALL_SLIDE,
	WALL_JUMP,
	ABILITY_DASH,
	ABILITY_SLIDE,
	ABILITY_STOMP,
}

var active_state := STATE.FALL

func knockback(knockback_direction: Vector2):
	switch_state(STATE.FALL)
	character.velocity += (knockback_direction * 10)
	character.velocity.y = character.velocity.y / 2

func reset_timer(timer: Timer) -> void:
	timer.stop()
	timer.time_left == 0
	
func _ready() -> void:
	change_state.emit(active_state)

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	
	match active_state:
		STATE.FLOOR:
			character.velocity.x = move_toward(character.velocity.x, direction * stats_component.WALK_VELOCITY, stats_component.ACCELERATION * delta)
			if Input.is_action_just_pressed("jump"):
				switch_state(STATE.JUMP)
			if not character.is_on_floor():
				switch_state(STATE.FALL)
			if Input.is_action_pressed("crouch"):
				switch_state(STATE.CROUCH)
			if Input.is_action_just_pressed("special_ability") and stats_component.can_slide and abs(character.velocity.x) >= 100 and %SlideTimer.time_left == 0:
				switch_state(STATE.ABILITY_SLIDE)
			
		STATE.JUMP:
			character.velocity.x = character.velocity.x + direction * stats_component.AIR_VELOCITY
			character.velocity.x = clamp(character.velocity.x, -stats_component.AIR_SPEED, stats_component.AIR_SPEED)
			character.velocity.y += stats_component.GRAVITY * delta
			if Input.is_action_just_pressed("special_ability") and stats_component.can_stomp and %StompTimer.time_left == 0:
				switch_state(STATE.ABILITY_STOMP)
			if Input.is_action_just_pressed("special_ability") and stats_component.can_dash and character.velocity.x != 0 and %DashTimer.time_left == 0:
				switch_state(STATE.ABILITY_DASH)
			if character.is_on_wall() and direction:
				switch_state(STATE.WALL_SLIDE)
			if Input.is_action_just_released("jump"):
				character.velocity.y = character.velocity.y * 0.5
			if character.velocity.y >= 0:
				switch_state(STATE.FALL)
			if Input.is_action_just_pressed("jump"):
				jump_buffer_timer.start()
			
		STATE.FALL:
			character.velocity.x = character.velocity.x + direction * stats_component.AIR_VELOCITY
			character.velocity.x = clamp(character.velocity.x, -stats_component.AIR_SPEED, stats_component.AIR_SPEED)
			character.velocity.y += stats_component.GRAVITY * delta
			if Input.is_action_just_pressed("jump"):
				if coyote_timer.time_left > 0:
					switch_state(STATE.JUMP)
				elif coyote_timer.time_left == 0 and stats_component.can_double_jump:
					stats_component.can_double_jump = false
					switch_state(STATE.JUMP)
			if Input.is_action_just_pressed("special_ability") and stats_component.can_stomp and %StompTimer.time_left == 0:
				switch_state(STATE.ABILITY_STOMP)
			if Input.is_action_just_pressed("special_ability") and stats_component.can_dash and character.velocity.x != 0 and %DashTimer.time_left == 0:
				switch_state(STATE.ABILITY_DASH)
			if character.is_on_wall() and direction:
				switch_state(STATE.WALL_SLIDE)
			if character.is_on_floor():
				switch_state(STATE.FLOOR)
			if Input.is_action_just_pressed("jump"):
				jump_buffer_timer.start()
		
		STATE.CROUCH:
			character.velocity.x = direction * stats_component.CROUCH_VELOCITY
			if Input.is_action_just_released("crouch"):
				switch_state(STATE.FLOOR)
			if not character.is_on_floor():
				switch_state(STATE.FALL)
			if Input.is_action_just_pressed("jump"):
				switch_state(STATE.JUMP)
				
		STATE.WALL_SLIDE:
			character.velocity.y = character.velocity.y + stats_component.GRAVITY / 2 * delta
			character.velocity.x = character.velocity.x + direction * stats_component.AIR_VELOCITY
			if Input.is_action_just_pressed("jump"):
				switch_state(STATE.WALL_JUMP)
			if not character.is_on_wall():
				switch_state(STATE.FALL)
				
		STATE.WALL_JUMP:
			character.velocity.y = character.velocity.y + stats_component.GRAVITY * delta
			if character.velocity.y <= 0:
				switch_state(STATE.JUMP)
			if character.velocity.y > 0:
				switch_state(STATE.FALL)
				
		STATE.ABILITY_SLIDE:
			character.velocity.y += stats_component.GRAVITY * delta
			character.velocity.x = move_toward(character.velocity.x, 0, 800 * delta)
			if Input.is_action_just_released("special_ability"):
				%SlideTimer.start(stats_component.SLIDE_COOLDOWN)
				switch_state(STATE.FLOOR)
			if Input.is_action_just_pressed("jump"):
				%SlideTimer.start(stats_component.SLIDE_COOLDOWN)
				switch_state(STATE.JUMP)
			if character.velocity.x == 0:
				%SlideTimer.start(stats_component.SLIDE_COOLDOWN)
				switch_state(STATE.FLOOR)
		
		STATE.ABILITY_STOMP:
			character.velocity.x = character.velocity.x + direction * stats_component.AIR_VELOCITY
			character.velocity.x = clamp(character.velocity.x, -stats_component.AIR_SPEED, stats_component.AIR_SPEED)
			character.velocity.y += stats_component.GRAVITY * 10 * delta
			if character.is_on_floor():
				switch_state(STATE.FLOOR)
				
		STATE.ABILITY_DASH:
			character.velocity.x = move_toward(character.velocity.x, 0, 5000 * delta)
			if character.is_on_floor():
				switch_state(STATE.FLOOR)
			if character.velocity.x == 0:
				switch_state(STATE.FALL)
	
	character.velocity.x = clamp(character.velocity.x, -stats_component.MAX_SPEED, stats_component.MAX_SPEED)
	if character.velocity.x > 0:
		character_sprite.flip_h = false
	if character.velocity.x < 0:
		character_sprite.flip_h = true
	character.move_and_slide()

func switch_state(to_state: STATE) -> void:
	var previous_state := active_state
	active_state = to_state
	change_state.emit(active_state)

	match active_state:
		STATE.FLOOR:
			stats_component.can_double_jump = true
			reset_timer(%DashTimer)
			if jump_buffer_timer.time_left > 0:
				switch_state(STATE.JUMP)
		STATE.JUMP:
			jump.play()
			reset_timer(%SlideTimer)
			character.velocity.y = stats_component.JUMP_VELOCITY
			coyote_timer.stop()
		STATE.FALL:
			if previous_state == STATE.FLOOR or previous_state == STATE.CROUCH:
				coyote_timer.start()
		STATE.CROUCH:
			pass
		STATE.WALL_SLIDE:
			stats_component.can_double_jump = true
			reset_timer(%DashTimer)
			character.velocity.y = character.velocity.y * 0.2
		STATE.WALL_JUMP:
			character.velocity.y = stats_component.JUMP_VELOCITY
			character.velocity.x = -character.get_wall_normal().x * stats_component.JUMP_VELOCITY
		STATE.ABILITY_SLIDE:
			slide.play()
			%SlideTimer.start(stats_component.SLIDE_COOLDOWN)
			character.velocity.x = character.velocity.x * 4
		STATE.ABILITY_STOMP:
			stomp.play()
			%StompTimer.start(stats_component.STOMP_COOLDOWN)
			character.velocity.x = 0
		STATE.ABILITY_DASH:
			dash.play()
			%DashTimer.start(stats_component.DASH_COOLDOWN)
			# I want to remove vertical velocity when dashing. When setting velocity.y to 0 it would
			# sometimes not behave as I intended so I simply lower it for now.
			character.velocity.y = character.velocity.y * 0.2
			# I am pretty sure this could be solved with one line, but this code works so I will
			# leave it like this.
			if character.velocity.x > 0:
					character.velocity.x = stats_component.MAX_SPEED
			if character.velocity.x < 0:
					character.velocity.x = -stats_component.MAX_SPEED
