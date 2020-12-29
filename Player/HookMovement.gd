extends MovementComponent

var hook_point
var start_distance
export (float) var gravity = 10.0
export (float) var max_speed = 100.0

func _ready():
	pass # Replace with function body.

func _input(_e):
	input()

func activate(point : Vector2):
	if point == Vector2.INF:
		return
	
	hook_point = point
	
	# $End.rotation = ray.get_collision_normal().angle() + PI
	
	start_distance = hook_point.distance_to(pawn.global_position)
	
	emit_signal("Hook")

func move():
	var hook_v = (hook_point - pawn.global_position).normalized()
	var direction
	if hook_v.cross(current_velocity) > 0:
		direction = hook_v.rotated(PI/2)
	else:
		direction = hook_v.rotated(-PI/2)
	
	if pawn.global_position.distance_to(hook_point) > start_distance:
		pawn.global_position = pawn.global_position.move_toward(
			hook_point,
			pawn.global_position.distance_to(hook_point) - start_distance
		)
	
	current_velocity = direction * (clamp(direction.dot(current_velocity) + direction.dot(gravity), -max_speed, max_speed))
