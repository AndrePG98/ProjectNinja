class_name PlayerInput extends Node

var move_direction: float = 0.0
var hook_pressed: bool = false
var jump_pressed: bool = false


func poll() -> void:
	move_direction = Input.get_axis("left", "right")
	hook_pressed = Input.is_action_just_pressed("interact")
	jump_pressed = Input.is_action_just_pressed("up")
