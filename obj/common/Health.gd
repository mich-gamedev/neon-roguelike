@icon("res://icons/health_class.svg")
extends Node
class_name Health

enum Team {PLAYER, ENEMY, NEUTRAL, NONE}

@export_group("Health Settings")
@export var team: Team = Team.ENEMY
@export var invincible: bool = false ## health can go below 0
@export_range(1,10, 1, "or_greater") var max_health: int = 8
@export_range(1,10, 1, "or_greater") var starting_health: int = 8
@export_group("Regeneration")
@export_range(0, 300, 0.01, "suffix:s", "or_greater") var regen_time: float = 60
@export_range(0, 10, 0.01, "suffix:s", "or_greater") var regen_offset: float = 3
@export_group("Actors")
@export var regen_timer: Timer
@export var offset_timer: Timer

@onready var health: float = starting_health
@onready var old_health: float = health
var dead := false

signal harmed(damage)
signal healed(amount)
signal died

func _process(_delta: float) -> void:
	if !invincible:
		health = clamp(health, 0, max_health)
	else:
		health = min(health, max_health)

func heal(amount):
	health += amount
	healed.emit(amount)
	if team == Team.PLAYER: 
		PlayerStats.player_healed.emit()
		print("Player healed for %d" % amount)
 
func harm(amount):
	health -= amount
	harmed.emit(amount)
	if team == Team.PLAYER: 
		PlayerStats.player_harmed.emit()
		print("Player harmed for %d" % amount)
		get_tree().paused = true
		await get_tree().create_timer(0.1).timeout
		get_tree().paused = false

	if health <= 0 and !dead:
		dead = true
		died.emit()
