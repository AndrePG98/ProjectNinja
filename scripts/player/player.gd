class_name Player extends Entity

var _swinging: bool = false
@onready var hook: Hook = $Hook


func _before_movement(_delta: float) -> void:
	hook.tick(intent.hook_pressed, intent.aim_position)
	_swinging = hook.attached and not is_on_floor()

	if _swinging:
		movement.remaining_jumps = 1
		if intent.jump_pressed:
			hook.release()
			_swinging = false


func _after_movement(_delta: float) -> void:
	hook.constraint(self)


func _get_swing_force() -> float:
	return hook.swing_force if _swinging else 0.0


func _derive_state() -> States.State:
	if hook.attached and not health.is_dead:
		return States.State.HOOKING

	return super._derive_state()
