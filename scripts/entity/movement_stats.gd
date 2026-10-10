class_name MovementStats extends Resource

@export_group("Ground")
## Horizontal speed (px/s) while on the floor.
@export var base_speed: float = 200.0
@export var max_speed: float = 500.0

@export_group("Jumping")
## Initial vertical velocity (px/s) of a jump. Negative is up
@export var jump_str: float = -450.0
## Jumps available before touching the floor again.
@export var total_jumps: int = 1

@export_group("Gravity")
## Multiplier on the project's gravity. Above 1 makes the player fall faster and feel heavier.
@export var gravity_multiplier: float = 1.3
## Maximum downward speed (px/s). Caps how fast the player can fall.
@export var terminal_velocity: float = 500.0

@export_group("Air Control")
## Fraction of base_speed used as the target speed in the air.
## 1.0 gives full air speed, 0.0 gives no air control.
@export_range(0, 1, 0.1) var air_speed_modifier: float = 0.7
## Acceleration when steering toward the air target speed.
## Higher gives snappier air control and quicker turnarounds.
@export var air_accel: float = 800.0
## Deceleration when coasting on excess speed or with no input.
## Lower is slipperier, and 0 never loses speed.
@export var air_drag: float = 150.0
