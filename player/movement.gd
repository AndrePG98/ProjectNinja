extends CharacterBody2D

@export var jump_str: float = -350.0
@export var speed: float = 200.0
@export var allowed_jumps: int = 2
@export var terminal_velocity: float = 500.0
@export var gravity_multiplier: float = 1.3

var screen_size: Vector2
var current_jumps: int


func _ready() -> void:
	screen_size = get_viewport_rect().size


func _physics_process(delta: float) -> void:
	handle_movement()
	handle_jump(delta)
	move_and_slide()


func handle_jump(delta: float) -> void:
	var jumped: bool = Input.is_action_just_pressed("up")

	if is_on_floor():
		current_jumps = allowed_jumps

	if not is_on_floor():
		if velocity.y > terminal_velocity:
			velocity.y = terminal_velocity
		else:
			velocity.y += get_gravity().y * gravity_multiplier * delta

	if jumped and current_jumps > 0:
		current_jumps -= 1
		velocity.y = jump_str


func handle_movement() -> void:
	var direction: float = Input.get_axis("left", "right")
	velocity.x = signf(direction) * speed
