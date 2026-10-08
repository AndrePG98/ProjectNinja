class_name CooldownIndicator extends TextureProgressBar

@export var hook: Hook


func _process(_delta: float) -> void:
	var time_left: float = hook.timer.time_left
	value = (time_left * max_value) / hook.hook_cooldown
