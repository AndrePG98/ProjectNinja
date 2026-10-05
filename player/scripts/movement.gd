extends CharacterBody2D

enum States { IDLE, RUNNING, JUMPING, FALLING, HOOKING }
const GROUNDED_STATES: Array[States] = [States.IDLE, States.RUNNING]
const AIRBORNE_STATES: Array[States] = [States.JUMPING, States.FALLING]
const STATE_ANIMATION_MAPPING: Dictionary[States, String] = {
	States.RUNNING: "run",
	States.JUMPING: "idle",
	States.FALLING: "idle",
	States.HOOKING: "idle",
	States.IDLE: "idle"
}

@export var jump_str: float = -450.0
@export var base_speed: float = 200.0
@export_range(0, 1, 0.1) var air_speed_modifier: float = 0.5
@export var swing_force: float = 500.0
@export var allowed_jumps: int = 1
@export var terminal_velocity: float = 500.0
@export var gravity_multiplier: float = 1.3

var current_allowed_jumps: int
var state: States = States.IDLE
var move_direction: float = 0.0
var is_jumping: bool = false
var is_hooking: bool = false

@onready var hook: Hook = $GrapplingHook
@onready var ui: TextureProgressBar = $HookCooldownIndicator
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _process(_delta: float) -> void:
	var time_left: float = hook.cooldown.time_left
	ui.value = (time_left * ui.max_value) / hook.hook_cooldown


func _physics_process(delta: float) -> void:
	handle_inputs()
	set_next_state()
	handle_animation()
	handle_movement(delta)
	move_and_slide()


func handle_inputs() -> void:
	move_direction = Input.get_axis("left", "right")
	is_hooking = Input.is_action_just_pressed("interact")
	is_jumping = Input.is_action_just_pressed("up") and current_allowed_jumps > 0


func handle_movement(delta: float) -> void:
	var speed: float = base_speed

	if is_on_floor():
		current_allowed_jumps = allowed_jumps
	else:
		speed *= air_speed_modifier
		velocity.y += get_gravity().y * gravity_multiplier * delta

	if is_jumping:
		current_allowed_jumps -= 1
		velocity.y = jump_str

	if hook.attached and not is_on_floor():
		velocity.x += move_direction * swing_force * delta
	else:
		velocity.x = signf(move_direction) * speed

	if hook.attached:
		var to_anchor: Vector2 = hook.anchor_point - global_position
		var dir: Vector2 = to_anchor.normalized()
		var d: float = to_anchor.length()
		var s: float = velocity.dot(dir)

		if d > hook.rope_length:
			if s < 0:
				velocity -= dir * s
			global_position += dir * (d - hook.rope_length)


func handle_animation() -> void:
	var animation_to_play: String = STATE_ANIMATION_MAPPING[state]
	animated_sprite.flip_h = velocity.x < 0
	animated_sprite.play(animation_to_play)


func set_next_state() -> Array[States]:
	var next_state: States = States.IDLE
	var prev_state: States = state

	if is_hooking:
		next_state = States.HOOKING

	elif is_jumping:
		next_state = States.JUMPING

	elif not is_on_floor() and velocity.y >= 0.0:
		next_state = States.FALLING

	elif is_on_floor() and move_direction != 0.0:
		next_state = States.RUNNING

	state = next_state
	return [prev_state, state]
