class_name Hook extends Node2D

@export var hook_length: float = 400.0
var hooked: bool = false
var anchor_point: Vector2 = Vector2.ZERO
var rope_length: float = 0.0
var attached: bool = false
var _debug_from: Vector2 = Vector2.ZERO
var _debug_to: Vector2 = Vector2.ZERO


func _draw() -> void:
	if not attached:
		return
	draw_line(to_local(_debug_from), to_local(_debug_to), Color.RED, 2.0)


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if attached:
			attached = false
			anchor_point = Vector2.ZERO
			rope_length = 0
			return

		var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
		var mouse_pos: Vector2 = get_global_mouse_position()
		var from: Vector2 = global_position
		var direction: Vector2 = mouse_pos - from
		var to: Vector2 = from + (direction.normalized() * hook_length)

		_debug_from = from
		_debug_to = to
		queue_redraw()

		var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(from, to, 2)

		var result: Dictionary = space_state.intersect_ray(query)
		if result.is_empty():
			return

		attached = true
		anchor_point = result.position
		rope_length = (anchor_point - from).length()
