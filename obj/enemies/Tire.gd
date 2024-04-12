@icon("res://assets/enemies/tire.png")
extends CharacterBody2D

@export var gravity = 960
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var blackboard: Blackboard = $Blackboard

func _physics_process(delta: float) -> void:
	if velocity.x: anim.scale.x = Util.get_bool_axis(velocity.x > 0)
	velocity.y += gravity * delta
	move_and_slide()


func _on_is_near_target_target_entered() -> void:
	anim.play(&"awake")

func _on_is_near_target_target_exited() -> void:
	anim.play(&"sleep")

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == &"awake":
		anim.play(&"roll")

func _on_health_harmed(damage: Variant) -> void:
	$AnimatedSprite2D/Hitflash.play("hitflash")
