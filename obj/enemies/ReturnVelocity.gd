extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	if !actor is CharacterBody2D: return FAILURE

	actor.velocity.x = move_toward(actor.velocity.x, 0.0, blackboard.get_value("friction") / 60.0)
	return SUCCESS
