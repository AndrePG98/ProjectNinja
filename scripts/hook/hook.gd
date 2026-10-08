class_name Hook extends Node2D

@export var hook_length: float = 200.0
@export var hook_cooldown: float = 1.0
@export var swing_force: float = 500.0
@export_flags_2d_physics var hook_mask: int = 2

var timer: Timer
var anchor_point: Vector2 = Vector2.ZERO
var rope_length: float = 0.0
var attached: bool = false
var _aim_to: Vector2 = Vector2.ZERO


func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = hook_cooldown
	add_child(timer)


func tick(fire_pressed: bool, aim_target: Vector2) -> void:
	_aim_to = Vector2.ZERO
	if not fire_pressed or not timer.is_stopped():
		queue_redraw()
		return

	if attached:
		_release()
		queue_redraw()
		return

	_try_attach(aim_target)
	queue_redraw()


func constraint(body: CharacterBody2D) -> void:
	if not attached:
		return

	var to_anchor: Vector2 = anchor_point - body.global_position
	var dir: Vector2 = to_anchor.normalized()
	var distance: float = to_anchor.length()
	if distance <= rope_length:
		return

	var s: float = body.velocity.dot(dir)
	if s < 0.0:
		body.velocity -= dir * s
	# body.global_position += dir * (distance - rope_length)


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


func _release() -> void:
	attached = false
	anchor_point = Vector2.ZERO
	rope_length = 0
	timer.start(hook_cooldown)


func _draw() -> void:
	if anchor_point:
		draw_line(Vector2.ZERO, to_local(anchor_point), Color.RED, 2.0)
		return

	if _aim_to:
		draw_line(Vector2.ZERO, to_local(_aim_to), Color.RED, 2.0)
