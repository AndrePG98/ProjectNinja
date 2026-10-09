class_name Intent extends RefCounted

var move_direction: float = 0.0
var jump_pressed: bool = false
var hook_pressed: bool = false
var hook_released: bool = false
var aim_position: Vector2 = Vector2.ZERO


func clear() -> void:
	move_direction = 0.0
	jump_pressed = false
	hook_pressed = false
	hook_released = false
	aim_position = Vector2.ZERO
