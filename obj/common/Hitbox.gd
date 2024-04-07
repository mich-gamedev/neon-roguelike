extends Area2D
class_name HitBox

enum dmg_mode{ON_ENTER, ON_EXIT, ON_COLLISION}

@export var health_actor: Health
@export var damage_mode : dmg_mode
@export var team := Health.Team.ENEMY
@export_range(0,1,0.01, "or_greater", "suffix:s") var damage_cooldown: float = 0
@export_group("Actors")
@export var cooldown_timer: Timer

var last_hurtbox: HurtBox

signal hurtbox_entered(hurtbox: HurtBox, direction: Vector2)

func _ready() -> void:
	priority = 256
	if damage_mode == dmg_mode.ON_ENTER:
		area_entered.connect(_harm)
	elif damage_mode == dmg_mode.ON_EXIT:
		area_exited.connect(_harm)

func _process(delta):
	if damage_mode == dmg_mode.ON_COLLISION:
		for i in get_overlapping_areas():
			_harm(i)

func _harm(area: Area2D) -> void:
	if area is HurtBox and (area.target == team or area.target == Health.Team.NEUTRAL):
		last_hurtbox = area
		health_actor.harm(area.damage)
		hurtbox_entered.emit(
			area,
			area.global_position.direction_to(global_position)
		)
