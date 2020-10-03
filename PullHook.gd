extends "res://B_Hook.gd"

export (float) var hook_time

var tween

var velocity : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func hook(var point : Vector2):
	.hook(point)
	
	tween = Tween.new()
	add_child(tween)
	
	var direction = (hook_point - pawn.position).normalized()
	
	tween.interpolate_property(self, "velocity", Vector2.ZERO, direction * max_speed, hook_time, Tween.TRANS_LINEAR)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	unhook()

func move(var _velocity : Vector2):
	
	return velocity
