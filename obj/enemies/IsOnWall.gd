extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	if !actor is CharacterBody2D: return FAILURE
	
	if actor.is_on_wall():
		return SUCCESS
	return FAILURE
