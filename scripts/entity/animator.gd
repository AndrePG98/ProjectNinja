class_name Animator extends Node

const STATE_ANIMATION_MAPPING: Dictionary[States.State, String] = {
	States.State.RUNNING: "run",
	States.State.JUMPING: "jump",
	States.State.FALLING: "idle",
	States.State.HOOKING: "idle",
	States.State.FAINT: "faint",
	States.State.IDLE: "idle"
}

@export var sprite: AnimatedSprite2D
@export var body: CharacterBody2D


func _ready() -> void:
	_play_for(States.State.IDLE)


func _process(_delta: float) -> void:
	if absf(body.velocity.x) > 0.1:
		sprite.flip_h = body.velocity.x < 0.0


func _on_state_changed(_prev: States.State, next: States.State) -> void:
	_play_for(next)


func _play_for(state: States.State) -> void:
	if sprite.sprite_frames == null:
		return

	var fallback: String = STATE_ANIMATION_MAPPING[States.State.IDLE]
	var animation: String = STATE_ANIMATION_MAPPING.get(state, fallback)
	if not sprite.sprite_frames.has_animation(animation):
		push_warning(
			"Missing animation '%s' for state %s" % [animation, States.State.find_key(state)]
		)
		return

	sprite.play(animation)
