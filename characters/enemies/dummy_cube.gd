extends CharacterBody2D

@export var enemy_health_component: EnemyHealthComponent
@export var knockback_strength := 1

func _ready() -> void:
	enemy_health_component.died.connect(_on_died)

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	velocity.x = move_toward(velocity.x, 0.0, 5.0)
	move_and_slide()
	
func knockback(knockback_direction: Vector2) -> void:
	velocity += knockback_direction * knockback_strength
	
func _on_died(node: CharacterBody2D) -> void:
	self.queue_free()
