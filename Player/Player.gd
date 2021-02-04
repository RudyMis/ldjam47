extends KinematicBody2D

signal dead

var map = null

func _ready():
	pass

func _process(delta):
	# Fullscreen
	if Input.is_action_just_pressed("ui_cancel"):
		OS.set_window_fullscreen(!OS.window_fullscreen)

func set_movement(val : bool):
	$MovementController.set_physics_process(val)

# Workaround narazie
func direction():
	if $Sprite.flip_h: return -1
	else: return 1



