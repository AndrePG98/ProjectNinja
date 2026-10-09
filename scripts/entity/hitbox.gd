class_name Hitbox extends Area2D

signal hit(hurtbox: Hurtbox)

@export var faction: Factions.Faction
@export var damage: int = 1
@export var multi_hit: bool = false

var _has_hit: bool = false


func _ready() -> void:
	monitoring = true
	monitorable = false
	area_entered.connect(_on_area_entered)


func _physics_process(_delta: float) -> void:
	if not multi_hit:
		return

	for area: Area2D in get_overlapping_areas():
		_on_area_entered(area)


func reset() -> void:
	_has_hit = false


func _on_area_entered(area: Area2D) -> void:
	if not area is Hurtbox:
		return

	var hurtbox: Hurtbox = area as Hurtbox
	_try_hit(hurtbox)


func _try_hit(hurtbox: Hurtbox) -> void:
	var not_interactable: bool = not Factions.can_interact(faction, hurtbox.faction)
	if (_has_hit and not multi_hit) or not_interactable :
		return

	if not hurtbox.receive_hit(damage):
		return

	_has_hit = true
	hit.emit(hurtbox)
