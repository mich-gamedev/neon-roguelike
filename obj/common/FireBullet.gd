@icon("res://icons/fire_bullet_class.svg")
extends Node2D
class_name FireBullet


@export_group("Bullet Scenes")
@export var particle: PackedScene

@export_group("Settings")
@export var do_physics_recoil: bool = true
@export var act_as_laser: bool = false

@export_range(0,1, 0.01) var velocity_bonus: float = 0.25

@export_group("Gun Stats")
@export var speed: float = 600
@export_range(0, 3, 0.01, "or_greater") var cooldown: float = 0.35
@export_range(0, 128, 0.5, "or_greater") var recoil: float = 25
@export_range(0,180, 0.1, "or_greater", "radians_as_degrees") var snap_angle: float

@export_group("Randomization")
@export_range(0,45,0.1,  "or_greater", "radians_as_degrees") var angle_variation: float
@export_range(0,300,0.1, "or_greater") var velocity_variation: float

@export_group("Multifire")
@export var amount: int = 1
@export_range(-180, 180, 0.1, "or_less", "or_greater", "radians_as_degrees") var field: float = 0.785398

@export_group("Actors")
@export var cooldown_timer: Timer

@onready var projectile_space: float = field / amount

var bullet_container: BulletContainer

signal bullet_fired
signal cooldown_timeout

func _ready() -> void:
	cooldown_timer.wait_time = cooldown
	for child in get_children():
		if child is BulletContainer:
			bullet_container = child
			break
func fire_bullet(direction: float):
	if cooldown_timer.time_left == 0:
		if particle:
			var spawned_particle = particle.instantiate()
			add_child(spawned_particle)
			spawned_particle.global_transform = global_transform

		for i in range(amount):
			var spawned_bullet = Bullet.new()
			if !act_as_laser:
				get_tree().root.add_child(spawned_bullet)
			else:
				get_carrier().add_child(spawned_bullet)
			set_up_bullet(spawned_bullet)
			spawned_bullet.global_position = global_position

			if spawned_bullet is CharacterBody2D:
				if amount > 1:
					var new_angle = direction + (i * projectile_space) - field / 2
					spawned_bullet.velocity = Vector2.from_angle(new_angle + randf_range(-angle_variation, angle_variation)) * (speed + randf_range(-velocity_variation, velocity_variation))
				else:
					spawned_bullet.velocity = Vector2.from_angle(direction + randf_range(-angle_variation, angle_variation)) * (speed + randf_range(-velocity_variation, velocity_variation))

				spawned_bullet.velocity += get_carrier().velocity * velocity_bonus

		if do_physics_recoil:
			get_carrier().velocity += (Vector2.from_angle(direction + PI) * (recoil*8)) - (get_carrier().velocity / 1.33)
		bullet_fired.emit()
		cooldown_timer.start()

func get_carrier() -> CharacterBody2D:
	if get_parent() is GunPivot:
		return get_parent().carrier
	else:
		print("Parent is not GunContainer")
		return

func set_up_bullet(new_bullet: Bullet):
	for child in bullet_container.get_children():
		new_bullet.add_child(child.duplicate())
	new_bullet.collision_particle = bullet_container.collision_particles
	new_bullet.bounces_left = bullet_container.bounces
	new_bullet.bounce_decay = bullet_container.bounce_decay
	new_bullet.collision_layer = bullet_container.layer
	new_bullet.collision_mask = bullet_container.mask
