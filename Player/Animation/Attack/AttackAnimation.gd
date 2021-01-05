extends Node2D

export (NodePath) var attack

onready var state_machine = $AnimationTree.get("parameters/playback")

func _ready():
	attack = get_node_or_null(attack)
	
	if attack:
		attack.connect("attack", self, "_attack")
		attack.connect("end_combo", self, "_end_combo")

func _attack():
	state_machine.travel("Attack")

func _end_combo():
	print("Tu")
	state_machine.travel("None")
