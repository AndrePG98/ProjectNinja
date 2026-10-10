class_name Entity extends CharacterBody2D

@export var controller: Controller

@onready var intent: Intent = Intent.new()
@onready var state_machine: StateMachine = $StateMachine
@onready var movement: Movement = $Movement
@onready var health: Health = $Health
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var animator: Animator = $Animator


func _ready() -> void:
	if not controller:
		controller = Controller.new()
	health.died.connect(_on_died)
	state_machine.state_changed.connect(animator._on_state_changed)
	hurtbox.hit_received.connect(health.damage)


func _physics_process(delta: float) -> void:
	_before_intent()
	_handle_intent()
	_before_movement(delta)
	movement.tick(delta, self, intent, _get_swing_force())
	_after_movement(delta)
	move_and_slide()
	state_machine.set_state(_derive_state())


func _handle_intent() -> void:
	intent.clear()
	if not controller or health.is_dead:
		return

	controller.fill(intent, self)


func _derive_state() -> States.State:
	if health.is_dead:
		return States.State.FAINT

	if not is_on_floor() and velocity.y >= 0.0:
		return States.State.FALLING

	if not is_on_floor() and velocity.y < 0.0:
		return States.State.JUMPING

	if absf(velocity.x) > 0.1:
		return States.State.RUNNING

	return States.State.IDLE


func _on_died() -> void:
	await get_tree().create_timer(1.0).timeout
	queue_free()


func _get_swing_force() -> float:
	return 0.0


func _before_intent() -> void:
	pass


func _before_movement(_delta: float) -> void:
	pass


func _after_movement(_delta: float) -> void:
	velocity = velocity.limit_length(movement.stats.max_speed)
