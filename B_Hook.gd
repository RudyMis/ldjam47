extends Node2D

signal Hook
signal Unhook

export (float) var hook_length = 200
export (Vector2) var gravity = Vector2(0, 10)
export (NodePath) var debug_path
export (float) var acceleration = 1
export (float) var max_speed = 200


onready var ray = $RayCast2D

enum Hook {
	IDLE,
	HOOK
}

onready var pawn = get_parent()

onready var debug_draw = get_node(debug_path)

var input_axis = 0

# Hook
var hook_point
var hook_state = Hook.IDLE

var start_distance = 0

func _ready():
	pass # Replace with function body.

func _input(event):
	
	input_axis = 0
	if Input.is_action_pressed("right"):
		input_axis += 1
	if Input.is_action_pressed("left"):
		input_axis -= 1
	
	if Input.is_action_just_pressed("hook"):
		var pos = ray_cast()
		if pos != Vector2.INF:
			hook(pos)
	if Input.is_action_just_released("hook"):
		unhook()

func _physics_process(delta):
	ray.cast_to = (get_global_mouse_position() - pawn.position).normalized() * hook_length

func ray_cast() -> Vector2:
	
	if ray.is_colliding():
		return ray.get_collision_point()
	return Vector2.INF

func hook(var point : Vector2):
	
	hook_state = Hook.HOOK
	hook_point = point
	
	start_distance = hook_point.distance_to(pawn.position)
	
	emit_signal("Hook")

func unhook():
	
	hook_state = Hook.IDLE
	
	emit_signal("Unhook")

func move(var velocity : Vector2) -> Vector2:
	var pos = pawn.position
	
	var hook_v = (hook_point - pos).normalized()
	
	var direction
	if hook_v.cross(velocity) > 0:
		direction = hook_v.rotated(PI/2)
	else:
		direction = hook_v.rotated(-PI/2)
	
	pawn.position = pawn.position.move_toward(hook_point, pawn.position.distance_to(hook_point) - start_distance)
	
	return direction * (clamp(direction.dot(velocity) + direction.dot(gravity), -max_speed, max_speed))

