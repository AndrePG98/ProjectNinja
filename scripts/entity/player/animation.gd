class_name PlayerAnimation extends Node

const STATE_ANIMATION_MAPPING: Dictionary[States.State, String] = {
	States.State.RUNNING: "run",
	States.State.JUMPING: "jump",
	States.State.FALLING: "idle",
	States.State.HOOKING: "idle",
	States.State.DEAD: "faint",
	States.State.IDLE: "idle"
}

@export var state_machine: StateMachine
@export var sprite: AnimatedSprite2D
@export var body: CharacterBody2D


func _ready() -> void:
	state_machine.state_changed.connect(_on_state_changed)
	sprite.play(STATE_ANIMATION_MAPPING[States.State.IDLE])


func _process(_delta: float) -> void:
	if absf(body.velocity.x) > 0.1:
		sprite.flip_h = body.velocity.x < 0.0


func _on_state_changed(_prev: States.State, next: States.State) -> void:
	var animation: String = STATE_ANIMATION_MAPPING.get(next, States.State.IDLE)
	sprite.play(animation)
