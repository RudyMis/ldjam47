extends MovementComponent

signal hook
signal unhook

export (float) var hook_length = 200
export (Vector2) var gravity = Vector2(0, 10)
export (float) var max_speed = 200

onready var ray = $Ray

# Hook
var hook_point
var direction = Vector2.ZERO

var start_distance = 0

func ray_cast() -> Vector2:
	
	if ray.is_colliding():
		return ray.get_collision_point()
	return Vector2.INF

func _ready():
	pass

func _process(delta):
	ray.cast_to = (get_global_mouse_position() - pawn.global_position).normalized() * hook_length

func input():
	pass

# Called when component is activated
func enter(var vel, var force, var p):
	
	current_velocity = vel
	pawn = p
	
	hook_point = ray_cast()
	
	if hook_point == Vector2.INF:
		return
	
	start_distance = hook_point.distance_to(pawn.global_position)
	
	emit_signal("hook", hook_point)

# Called when component is desactivated
func leave():
	pass

# Movement logic goes here
func move():
	var hook_v = (hook_point - pawn.global_position).normalized()
	if hook_v.cross(current_velocity) > 0:
		direction = hook_v.rotated(PI/2)
	else:
		direction = hook_v.rotated(-PI/2)
	current_velocity = direction * (clamp(direction.dot(current_velocity) + direction.dot(gravity), -max_speed, max_speed))
	# if pawn.global_position.distance_to(hook_point) > start_distance:
		# current_velocity += pawn.global_position.move_toward(hook_point, pawn.global_position.distance_to(hook_point) - start_distance)

# Collision logic goes here
func update_collision():
	pass
