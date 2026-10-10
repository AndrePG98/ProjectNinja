class_name Health extends Node

signal died
signal changed(previous: int, current: int)
@export var total_health: int = 1

var current_health: int
var is_dead: bool


func _ready() -> void:
	current_health = total_health
	is_dead = false


func _change(amount: int) -> void:
	if is_dead or amount == 0:
		return

	var prev_health: int = current_health
	current_health = clampi(current_health + amount, 0, total_health)

	if prev_health == current_health:
		return

	changed.emit(prev_health, current_health)

	if current_health <= 0:
		is_dead = true
		died.emit()


func damage(amount: int) -> void:
	_change(-amount)


func heal(amount: int) -> void:
	_change(amount)


func get_health() -> int:
	return current_health
