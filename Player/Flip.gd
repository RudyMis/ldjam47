extends Node2D

export (NodePath) var movement

func _ready():
	movement = get_node(movement)

func _process(delta):
	if movement:
		if sign(movement.get_current_velocity().x) == -scale.x:
			scale.x = -scale.x
