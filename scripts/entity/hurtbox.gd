class_name Hurtbox extends Area2D

signal hit_received(damage: int)
signal invincibility_changed(active: bool)

@export var faction: Factions.Faction = Factions.Faction.NEUTRAL
@export var invincibility_time: float = 1.0

var is_invincible: bool = false
var _timer: Timer


func _ready() -> void:
	_timer = Timer.new()
	_timer.one_shot = true
	_timer.timeout.connect(_on_timer_timeout)
	add_child(_timer)


func receive_hit(damage: int) -> bool:
	if is_invincible:
		return false

	if invincibility_time > 0.0:
		is_invincible = true
		_timer.start(invincibility_time)
		invincibility_changed.emit(true)

	hit_received.emit(damage)
	return true


func _on_timer_timeout() -> void:
	is_invincible = false
	invincibility_changed.emit(false)
