extends KinematicBody2D

signal dead

onready var movement = $MovementComponent

func _ready():
	pass # Replace with function body.

func die():
	
	movement.dying = true
	
	yield(get_tree().create_timer(0.6), "timeout")
	
	emit_signal("dead")
	
	queue_free()

