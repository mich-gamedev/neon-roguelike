extends Node
class_name DeleteOnDeath

@export var health_actor: Health
@export var main_parent: Node
@export_range(0,5,0.01, "or_greater", "suffix:s") var delay: float

func _ready() -> void:
	health_actor.died.connect(delete_owner)

func delete_owner():
	await get_tree().create_timer(delay).timeout
	main_parent.queue_free()
