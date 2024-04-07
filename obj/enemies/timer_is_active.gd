extends ConditionLeaf

@export var timer: Timer
func tick(actor: Node, blackboard: Blackboard) -> int:
	if is_instance_valid(timer):
		if timer.time_left: return FAILURE
		else: return SUCCESS
	return FAILURE

