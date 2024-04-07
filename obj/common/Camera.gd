extends Camera2D

var cam_limits: Rect2

func _ready() -> void:
	reset_smoothing()

func _process(_delta: float) -> void:
	if PlayerStats.cam_limits != Rect2(Vector2.ZERO, Vector2.ZERO):
		cam_limits = PlayerStats.cam_limits
		limit_left = int(cam_limits.position.x)
		limit_top = int(cam_limits.position.y)
		limit_right = int(cam_limits.end.x)
		limit_bottom = int(cam_limits.end.y)
