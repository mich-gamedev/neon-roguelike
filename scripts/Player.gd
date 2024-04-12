@icon("res://assets/player/player_ico.png")
extends CharacterBody2D

#region Exports
@export_group("Horizontal Movement")
@export var speed: int = 240
@export var ground_friction: int = 15000

@export_group("Vertical Movement")
@export var floor_jump_speed: int = 400
@export var air_gravity: int = 1500
@export var terminal_velocity: int = 750

@export_group("BG sliding")
@export var sliding_speed: int = 50
@export var air_jump_speed: int = 480

@export_group("Wall Sliding")
@export var wall_gravity: int = 500
@export var kick_speed: int = 64

@export_group("Air movement")
@export var air_friction: int = 1200
@export var recoil_friction: int = 360
@export var air_trans: float = 560
#endregion


#region References
@onready var slide_collider: Area2D = $SlidingWallCollider
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var gun_pivot: GunPivot = $GunContainer
@onready var cam: Camera2D = $Camera2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_particle: AnimatedSprite2D = $JumpParticle
@onready var particles: GPUParticles2D = $AnimatedSprite2D/GPUParticles2D
#endregion


#region Variables
var friction: float
var current_falling_speed: float
var max_falling_speed : float
var can_wall_jump : bool = false
var debug := true
var was_on_floor := false
var can_jump := true
var jumping := false
#endregion
func _process(_delta: float) -> void:
	var cam_pos: Vector2 = cam.get_local_mouse_position() / 2.0
	cam.position = cam_pos.normalized() * clamp(cam_pos.length(), 0.0, 128.0)
func _physics_process(delta: float) -> void:
#region Calls
	input_control(delta)
	environment_control(delta)
#endregion

#region PlayerStats Updates
	PlayerStats.pos = position
	PlayerStats.vel = velocity
	PlayerStats.hp = $Health.health
	PlayerStats.max_hp = $Health.max_health
#endregion

	
	gun_pivot.target_vector = get_local_mouse_position()
	
	if Input.is_action_pressed("fire"):
		gun_pivot.fire_current_gun(gun_pivot.rotation)
	if debug and Input.is_action_just_pressed("spawn_enemy"):
		var enemy = load("res://obj/enemies/Tire.tscn").instantiate()
		get_tree().current_scene.add_child(enemy)
		enemy.global_position = get_global_mouse_position()
	move_and_slide()

func _on_sliding_wall_entered(_body: Node2D) -> void:
	can_wall_jump = true
func _on_sliding_wall_exited(_body: Node2D) -> void:
	can_wall_jump = false

func input_control(delta: float) -> void:
#region Movement
	var input_axis: float = Input.get_axis("move_left", "move_right")
	if input_axis:
		velocity.x = move_toward(velocity.x, input_axis * speed, friction * delta)
		var flip_tween: Tween = get_tree().create_tween()
		flip_tween.tween_property(anim, "scale", Vector2(input_axis, 1), 0.1)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	
	if Input.is_action_just_pressed("jump"):
		if can_jump:
			jump_particle.global_position = global_position
			jump_particle.visible = true
			jump_particle.scale = anim.scale
			jump_particle.play("default")
			velocity.y = -floor_jump_speed
		elif can_wall_jump and (max_falling_speed == sliding_speed):
			velocity.y = -air_jump_speed
			can_wall_jump = false
#endregion

#region Gun Swapping
	if Input.is_action_just_pressed("next_item"):
		gun_pivot.gun_index += 1
		print(wrap(gun_pivot.gun_index, 0, gun_pivot.carried_guns.size()))
	if Input.is_action_just_pressed("previous_item"):
		gun_pivot.gun_index -= 1
		print(wrap(gun_pivot.gun_index, 0, gun_pivot.carried_guns.size()))
#endregion
func environment_control(delta: float) -> void:
	if is_on_floor():
		coyote_timer.stop()
		can_jump = true
		was_on_floor = true
		friction = ground_friction
		can_wall_jump = true
		if velocity == Vector2.ZERO:
			particles.emitting = false
			anim.play("Idle")
		else:
			particles.emitting = true
			anim.play("Run")
	else:
		particles.emitting = false
		friction = move_toward(friction, air_friction, air_trans * delta)
		velocity.y = move_toward(velocity.y, max_falling_speed, air_gravity * delta)
		if velocity.y < 0:
			anim.play("Jump")
		if velocity.y >= 0:
			anim.play("Fall")
	
	if Input.is_action_pressed("slide") and slide_collider.has_overlapping_bodies():
		particles.emitting = true
		max_falling_speed = sliding_speed
		anim.play("BG Slide")
	else:
		max_falling_speed = terminal_velocity
	
	if Input.is_action_just_pressed("slide"):
		can_wall_jump = true
	if !is_on_floor() and was_on_floor:
		coyote_timer.start()
		was_on_floor = false
func _on_gun_container_current_gun_fired(_direction: float) -> void:
	friction = recoil_friction


func _on_coyote_timer_timeout() -> void:
	can_jump = false

func _on_health_harmed(_damage: Variant) -> void:
	$AnimatedSprite2D/Hitflash.play(&"hitflash")
