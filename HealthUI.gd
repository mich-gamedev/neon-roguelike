extends ReferenceRect

@onready var label: RichTextLabel = $Label
@onready var bar: TextureProgressBar = $HealthBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	PlayerStats.player_harmed.connect(change_bar)
	PlayerStats.player_healed.connect(change_bar)
	change_bar()

func change_bar() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	var hp = get_tree().get_first_node_in_group(&"player_health").health
	var max_hp =get_tree().get_first_node_in_group(&"player_health").max_health

	var tw: Tween = create_tween()
	tw.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tw.tween_property(bar, "value", hp, 0.33)
	tw.parallel().tween_property(bar, "max_value", max_hp, 0.33)

	label.text = "[shake rate=20.0 level=10][color=#ff5dcc]HP:%d/%d" % [hp, max_hp]
	await get_tree().create_timer(0.1).timeout
	label.text = "[color=#ff5dcc]HP:%d/%d" % [hp, max_hp]
	await get_tree().create_timer(0.1).timeout

	if hp >= max_hp - 2:
		label.text = "[wave amp=5.0][color=#ff5dcc]HP:[/color]%d/%d" % [hp, max_hp]
	elif hp <= max_hp / 2.5:
		label.text = "[shake][color=#ff5dcc]HP:[/color]%d/%d" % [hp, max_hp]
	else:
		label.text = "[color=#ff5dcc]HP:[/color]%d/%d" % [hp, max_hp]
