class_name PlayerController extends Controller


func fill(intent: Intent, body: Entity) -> void:
	intent.move_direction = Input.get_axis("left", "right")
	intent.hook_pressed = Input.is_action_just_pressed("interact")
	intent.hook_released = Input.is_action_just_released("interact")
	intent.jump_pressed = Input.is_action_just_pressed("up")
	intent.aim_position = body.get_global_mouse_position()
