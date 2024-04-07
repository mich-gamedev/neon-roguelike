@icon("res://icons/bullet_class.svg")
extends CharacterBody2D
class_name Bullet
@export var collision_particle: PackedScene

var bounces_left: int
var bounce_decay: float
var damage: float
var collided: bool
func _physics_process(delta: float) -> void:
	var coll_info = move_and_collide(velocity * delta)
	if coll_info:
		velocity = velocity.bounce(coll_info.get_normal()) * bounce_decay

		if collision_particle:
			var new_particle: GPUParticles2D = collision_particle.instantiate() as GPUParticles2D
			if coll_info.get_collider() is CharacterBody2D:
				coll_info.get_collider().add_child(new_particle)
				new_particle.lifetime /= 3
			else:
				get_tree().current_scene.add_child(new_particle)
			new_particle.global_position = global_position - (velocity.normalized() * 3)

		if bounces_left == 0:
			await get_tree().process_frame
			queue_free()
		set_deferred("bounces_left", bounces_left - 1)
	else:
		collided = false
static func get_bullet(node: Node) -> Bullet:
	if node.get_parent() is Bullet:
		return node.get_parent()
	else:
		return
