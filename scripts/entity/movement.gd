class_name Movement extends Node

@export var stats: MovementStats

var remaining_jumps: int


func tick(delta: float, body: CharacterBody2D, intent: Intent, swing_force: float) -> void:
	_reset_jumps(body)
	_apply_gravity(delta, body)
	_handle_jump(intent.jump_pressed, body)
	_handle_movement(delta, signf(intent.move_direction), swing_force, body)


func _handle_movement(
	delta: float, direction: float, momentum: float, body: CharacterBody2D
) -> void:
	if body.is_on_floor():
		body.velocity.x = direction * stats.base_speed
		return

	if momentum > 0.0:
		body.velocity.x += direction * momentum * delta
		return

	var air_target: float = direction * stats.base_speed * stats.air_speed_modifier

	# If current speed > input speed and the same direction
	var overspeed: bool = (
		absf(body.velocity.x) > absf(air_target) and signf(body.velocity.x) == signf(air_target)
	)

	var rate: float = stats.air_drag if (direction == 0.0 or overspeed) else stats.air_accel
	body.velocity.x = move_toward(body.velocity.x, air_target, rate * delta)


func _handle_jump(jumped: bool, body: CharacterBody2D) -> void:
	if not jumped or remaining_jumps <= 0:
		return

	remaining_jumps -= 1
	body.velocity.y = stats.jump_str


func _reset_jumps(body: CharacterBody2D) -> void:
	if not body.is_on_floor():
		return

	remaining_jumps = stats.total_jumps


func _apply_gravity(delta: float, body: CharacterBody2D) -> void:
	if body.is_on_floor():
		return

	body.velocity.y += body.get_gravity().y * stats.gravity_multiplier * delta
	body.velocity.y = minf(body.velocity.y, stats.terminal_velocity)
