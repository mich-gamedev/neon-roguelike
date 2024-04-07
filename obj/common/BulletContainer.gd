@icon("res://icons/bullet_class.svg")
extends Node2D
class_name BulletContainer

@export var bounces := 0
@export_range(0, 1, 0.01, "or_greater") var bounce_decay := 1.0
@export var collision_particles : PackedScene = preload("res://obj/particles/collision_graffiti.tscn")
@export_flags_2d_physics var layer: int
@export_flags_2d_physics var mask: int = 2

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
