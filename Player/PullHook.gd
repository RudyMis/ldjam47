extends "res://Player/B_Hook.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func hook(var point : Vector2):
	if point == Vector2.INF:
		return
	
	.hook(point)
	

func move(var _velocity : Vector2):
	
	direction = (hook_point - pawn.global_position + Vector2(0, -8)).normalized()
	
	var delta = pawn.global_position.distance_to(hook_point + Vector2(0, -8)) / start_distance
	
	if delta < 0.2:
		.unhook()
	
	return lerp(direction * max_speed / 2, direction * max_speed, 1 - delta)
