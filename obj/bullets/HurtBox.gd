extends Area2D
class_name HurtBox

@export var damage: float = 1
@export var kill_on_collision: bool = false
@export var target: Health.Team

func _ready() -> void:
	priority = 256
