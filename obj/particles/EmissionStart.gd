extends Node
class_name ParticleOneShot

@export var particle: GPUParticles2D
@export var delay: float = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(delay).timeout
	particle.emitting = true
