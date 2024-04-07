extends HurtBox

func _ready() -> void:
	body_entered.connect(remove_bounce)

func remove_bounce(body: Node2D) -> void:
	print("From %d" % Bullet.get_bullet(self).bounces_left)
	Bullet.get_bullet(self).bounces_left -= 1
	print("To %d" % Bullet.get_bullet(self).bounces_left)
	if Bullet.get_bullet(self).bounces_left <= 0:
		print(Bullet.get_bullet(self).bounces_left)
		Bullet.get_bullet(self).delete_bullet()
