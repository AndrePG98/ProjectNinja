class_name Hook extends Node2D

@export var hook_length: float = 300.0
@export var hook_cooldown: float = 1.0

var hooked: bool = false
var anchor_point: Vector2 = Vector2.ZERO
var rope_length: float = 0.0
var attached: bool = false
var to: Vector2 = Vector2.ZERO

@onready var cooldown: Timer = $Cooldown


func _draw() -> void:
	if anchor_point:
		draw_line(global_position, anchor_point, Color.RED, 2.0)
		return

	if to:
		draw_line(global_position, to, Color.RED, 2.0)


func _physics_process(_delta: float) -> void:
	to = Vector2.ZERO
	if not Input.is_action_just_pressed("interact"):
		queue_redraw()
		return

	if attached:
		reset_hook()
		queue_redraw()
		return

	if not cooldown.is_stopped():
		queue_redraw()
		return

	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var mouse_pos: Vector2 = get_global_mouse_position()
	var from: Vector2 = global_position

	var direction: Vector2 = mouse_pos - from
	to = from + (direction.normalized() * hook_length)
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(from, to, 2)

	var result: Dictionary = space_state.intersect_ray(query)
	if not result.is_empty():
		attached = true
		anchor_point = result.position
		rope_length = (anchor_point - from).length()

	queue_redraw()
	cooldown.start(hook_cooldown)


func reset_hook() -> void:
	attached = false
	anchor_point = Vector2.ZERO
	to = Vector2.ZERO
	rope_length = 0
