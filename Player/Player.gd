extends KinematicBody2D

signal dead

var map = null

func _ready():
	pass

func _process(delta):
	pass

func set_movement(val : bool):
	$MovementController.set_physics_process(val)

# Workaround narazie
func direction():
	if $Sprite.flip_h: return -1
	else: return 1



