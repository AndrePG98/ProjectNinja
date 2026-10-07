class_name MovementStats extends Resource

@export var jump_str: float = -450.0
@export var base_speed: float = 200.0
@export_range(0, 1, 0.1) var air_speed_modifier: float = 0.5
@export var total_jumps: int = 1
@export var terminal_velocity: float = 500.0
@export var gravity_multiplier: float = 1.3
