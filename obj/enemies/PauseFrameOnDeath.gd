extends Node
class_name PauseFrameOnDeath

@export var health: Health
@export_range(0.001, 0.2, 0.001, "or_less", "or_greater", "suffix:s") var time: float = 0.05
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health.died.connect(pause_frame)

func pause_frame() -> void:
	get_tree().paused = true
	await get_tree().create_timer(time).timeout
	get_tree().paused = false
