tool
extends Node2D

export (Resource) var SM_Graph

func _ready():
	pass

func get_states():
	var s = Array()
	for child in get_children(): 
		if "sm_type" in child:
			if child.get("sm_type") == StateMachine.Type.State:
				pass
