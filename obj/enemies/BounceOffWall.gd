extends ActionLeaf

@export var speed: float = 320
signal bounced_on_wall

func tick(actor: Node, blackboard: Blackboard) -> int:
	if !actor is CharacterBody2D: return FAILURE
	
	actor.velocity = Vector2(-actor.velocity.x / 2, -actor.velocity.length())
	bounced_on_wall.emit()
	return SUCCESS
