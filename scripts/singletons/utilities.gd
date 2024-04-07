extends Node

func get_bool_axis(boolean : bool) -> int:
	return lerp(-1, 1, int(boolean))

func _ready() -> void:
	Engine.physics_ticks_per_second = DisplayServer.screen_get_refresh_rate()
