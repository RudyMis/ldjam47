extends "res://Player/B_Hook.gd"

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
	
	var t = hook_time
	var s = pawn.position.distance_to(hook_point)
	
	var v = 4 * s / (2 * t + t * t)
	
	tween.interpolate_property(self, "velocity", direction * v / 2, direction * v, hook_time, Tween.TRANS_LINEAR)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	unhook()

func move(var _velocity : Vector2):
	
	return velocity
