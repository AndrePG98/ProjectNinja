class_name Player extends CharacterBody2D

@onready var input: PlayerInput = $PlayerInput
@onready var movement: Movement = $Movement
@onready var hook: Hook = $Hook
@onready var state_machine: StateMachine = $StateMachine


func _physics_process(delta: float) -> void:
	input.poll()
	hook.tick(input.hook_pressed, get_global_mouse_position())

	var swinging: bool = hook.attached and not is_on_floor()

	if swinging:
		movement.remaining_jumps = 1
		if input.jump_pressed:
			hook.release()
			swinging = false

	var swing_force: float = hook.swing_force if swinging else 0.0
	movement.tick(delta, self, input.move_direction, swing_force, input.jump_pressed)
	hook.constraint(self)

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
