class_name Movement extends Node

@export var stats: MovementStats

var remaining_jumps: int


func tick(
	delta: float,
	body: CharacterBody2D,
	direction: float,
	jumped: bool,
	velocity_modifier: float = 0.0
) -> void:
	var speed: float = stats.base_speed

	if body.is_on_floor():
		remaining_jumps = stats.total_jumps
	else:
		speed *= stats.air_speed_modifier
		body.velocity.y += body.get_gravity().y * stats.gravity_multiplier * delta
		body.velocity.y = minf(body.velocity.y, stats.terminal_velocity)

	if jumped and remaining_jumps > 0:
		remaining_jumps -= 1
		body.velocity.y = stats.jump_str

	if velocity_modifier > 0.0:
		body.velocity.x += direction * velocity_modifier * delta
	else:
		body.velocity.x = signf(direction) * speed
