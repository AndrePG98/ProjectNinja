class_name Hook extends Node2D

signal released

@export var hook_length: float = 200.0
@export var hook_cooldown: float = 1.0
@export var swing_force: float = 500.0
@export var swing_launch: float = 100.0
@export var swing_damping: float = 0.5
@export_flags_2d_physics var hook_mask: int = 2

var timer: Timer
var anchor_point: Vector2 = Vector2.ZERO
var rope_length: float = 0.0
var attached: bool = false
var _aim_to: Vector2 = Vector2.ZERO

@onready var line_2d: Line2D = $Line2D


func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = hook_cooldown
	add_child(timer)


func _process(_delta: float) -> void:
	if attached and line_2d.get_point_count() == 2:
		line_2d.set_point_position(1, line_2d.to_local(anchor_point))


func tick(body: Entity, intent: Intent, aim_target: Vector2) -> void:
	_aim_to = Vector2.ZERO
	if not timer.is_stopped() or (not attached and body.is_on_floor()):
		return

	if attached and (intent.hook_released or intent.jump_pressed or body.is_on_floor()):
		release()
	elif intent.hook_pressed and not attached:
		_try_attach(aim_target)


func release() -> void:
	if not attached:
		return

	line_2d.clear_points()
	attached = false
	anchor_point = Vector2.ZERO
	rope_length = 0
	released.emit()
	timer.start(hook_cooldown)


func constraint(body: Entity) -> void:
	if not attached:
		return

	var to_anchor: Vector2 = anchor_point - global_position
	var dir: Vector2 = to_anchor.normalized()
	var distance: float = to_anchor.length()
	if distance <= rope_length:
		return

	var s: float = body.velocity.dot(dir)
	if s < 0.0:
		body.velocity -= dir * s
	body.global_position += dir * (distance - rope_length)


func _try_attach(aim_target: Vector2) -> void:
	var from: Vector2 = global_position
	var dir: Vector2 = (aim_target - from).normalized()
	_aim_to = from + dir * hook_length

	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
		from, _aim_to, hook_mask
	)
	var result: Dictionary = get_world_2d().direct_space_state.intersect_ray(query)

	if result.is_empty():
		timer.start(hook_cooldown)
		return

	attached = true
	anchor_point = result.position
	rope_length = (anchor_point - from).length()
	line_2d.clear_points()
	line_2d.add_point(Vector2.ZERO, 0)
	line_2d.add_point(line_2d.to_local(anchor_point), 1)
