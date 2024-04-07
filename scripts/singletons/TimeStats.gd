extends Node

#todo - set to false, when main menu is created
var counting: bool = true ##Determines if the game time should be running or not.
var time_sec: float ##Amount of time the game has been playing, in seconds.


func _process(delta: float) -> void:
	if counting: time_sec += delta
