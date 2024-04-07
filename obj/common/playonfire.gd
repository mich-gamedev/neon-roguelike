extends AnimatedSprite2D
class_name PlayAnimationOnFire
@export var animation_name: String = "default"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_parent() is FireBullet:
		get_parent().bullet_fired.connect(func(): play(animation_name))
