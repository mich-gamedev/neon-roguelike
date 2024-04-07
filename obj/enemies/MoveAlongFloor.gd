extends ActionLeaf
class_name MoveAlongFloor

@export var speed: float = 480


var delta_time: float

func _process(delta: float) -> void:
	delta_time = delta

func tick(actor: Node, blackboard: Blackboard) -> int:
	if !actor is CharacterBody2D: return FAILURE

	var targets = get_tree().get_nodes_in_group(blackboard.get_value("target"))
	targets.sort_custom(func(a, b): 
		return abs(actor.global_position - a.global_position) > abs(actor.global_position - b.global_position))
	blackboard.set_value("targets", targets)

	var direction = Util.get_bool_axis(actor.to_local(blackboard.get_value("targets")[0].global_position).x > 0)
	actor.velocity.x = move_toward(
		actor.velocity.x,
		direction * speed,
		blackboard.get_value("acceleration") / 60)
	return SUCCESS
