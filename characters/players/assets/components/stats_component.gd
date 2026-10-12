extends Node
class_name StatsComponent

# Movement
@export var WALK_VELOCITY := 400.0
@export var CROUCH_VELOCITY := 150.0
@export var JUMP_VELOCITY := -500.0
@export var GRAVITY := 1500.0
@export var ACCELERATION := 5000
@export var AIR_VELOCITY := 5000
@export var AIR_SPEED := 400
@export var MAX_SPEED := 1500

# Special abilities
@export var can_dash := false
@export var DASH_COOLDOWN := 5
@export var can_stomp := false
@export var STOMP_COOLDOWN := 1
@export var can_slide := false
@export var SLIDE_COOLDOWN := 2
@export var can_double_jump := true
