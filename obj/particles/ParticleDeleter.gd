extends Node
class_name ParticleDeleter

@export var particle: GPUParticles2D
@export var actor: Node
@export_exp_easing var test: float
func _ready() -> void:
	await particle.finished
	actor.queue_free()
