extends ConditionLeaf 
class_name IsNearTarget

signal target_entered()
signal target_exited()

@export var sight_range: float = 128
var last_actor_in_range: bool

func tick(actor: Node, blackboard: Blackboard) -> int:
	var actor_in_range := false
	if !actor is Node2D: 
		push_error("%s is not a Node2D, and cannot compare it's position" % actor.name)
		return FAILURE

	for i : Node2D in get_tree().get_nodes_in_group(blackboard.get_value("target")):
		if actor.global_position.distance_squared_to(i.global_position) <= sight_range ** 2:
			actor_in_range = true

	if last_actor_in_range != actor_in_range:
		if actor_in_range: target_entered.emit()
		else: target_exited.emit()
		last_actor_in_range = actor_in_range

	if actor_in_range:
		return SUCCESS
	else:
		return FAILURE
