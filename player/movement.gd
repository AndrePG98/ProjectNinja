extends CharacterBody2D

@export var jump_str: float = -450.0
@export var speed: float = 200.0
@export var allowed_jumps: int = 2
@export var terminal_velocity: float = 500.0
@export var gravity_multiplier: float = 1.3

var screen_size: Vector2
var current_jumps: int

@onready var hook: Hook = $GrapplingHook


func _ready() -> void:
	screen_size = get_viewport_rect().size


func _physics_process(delta: float) -> void:
	handle_movement()
	handle_jump(delta)
	move_and_slide()


func handle_jump(delta: float) -> void:
	if hook.attached:
		var to_anchor: Vector2 = (hook.anchor_point - global_position)
		var dir : Vector2 = to_anchor.normalized()
		var d: float = to_anchor.length()
		var s: float = velocity.dot(dir)

		if d > hook.rope_length:
			if s < 0:
				velocity -= dir * s
			global_position += dir * (d - hook.rope_length)

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
