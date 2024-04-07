extends Node

@export var hitbox: HitBox
@export var splatter: PackedScene = preload("res://obj/particles/death_splatter.tscn")
var last_hurtbox : HurtBox
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.health_actor.died.connect(died)
	hitbox.area_entered.connect(func(area): if area is HurtBox: last_hurtbox = area)


func died() -> void: 
	var player = get_tree().get_first_node_in_group(&"player")
	var splatter_instance: GPUParticles2D = splatter.instantiate() as GPUParticles2D
	splatter_instance.global_position = owner.global_position
	splatter_instance.global_rotation = (player.global_position + (Vector2.DOWN * 16)).direction_to(owner.global_position).angle()
	get_tree().current_scene.add_child(splatter_instance)
	splatter_instance.emitting = true
