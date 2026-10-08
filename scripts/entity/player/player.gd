class_name Player extends CharacterBody2D

@onready var input: PlayerInput = $PlayerInput
@onready var movement: Movement = $Movement
@onready var hook: Hook = $Hook
@onready var state_machine: StateMachine = $StateMachine


func _physics_process(delta: float) -> void:
	input.poll()
	hook.tick(input.hook_pressed, get_global_mouse_position())

	var swing_force: float = hook.swing_force if hook.attached and not is_on_floor() else 0.0

	if hook.attached and not is_on_floor():
		movement.remaining_jumps = 1

	movement.tick(delta, self, input.move_direction, swing_force, input.jump_pressed)
	hook.constraint(self)

	if hook.attached && input.jump_pressed && velocity.y < 0.0:
		hook._release()

	move_and_slide()
	_update_state()


func _update_state() -> void:
	var next: States.State = States.State.IDLE

	if hook.attached:
		next = States.State.HOOKING
	elif not is_on_floor() and velocity.y >= 0.0:
		next = States.State.FALLING
	elif not is_on_floor() and velocity.y < 0.0:
		next = States.State.JUMPING
	elif absf(velocity.x) > 0.1:
		next = States.State.RUNNING

	state_machine.set_state(next)
