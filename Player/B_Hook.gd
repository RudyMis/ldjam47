extends Node2D

signal Hook
signal Unhook

export (float) var hook_length = 200
export (Vector2) var gravity = Vector2(0, 10)
export (float) var acceleration = 1
export (float) var max_speed = 200
export (float) var force = 200
export (Vector2) var force_dir = Vector2(1, 1)

onready var ray = $RayCast2D

enum Hook {
	IDLE,
	HOOK
}

onready var pawn = get_parent()

var b_active = false

# Hook
var hook_point
var hook_state = Hook.IDLE
var direction = Vector2.ZERO

var start_distance = 0

func _ready():
	pass # Replace with function body.

func _input(_event):
	
	if !b_active:
		return
	
	if Input.is_action_just_pressed("hook"):
		hook(ray_cast())
	if Input.is_action_just_released("hook"):
		unhook()

func _physics_process(_delta):
	
	if !b_active:
		return
	
	ray.cast_to = (get_global_mouse_position() - global_position).normalized() * hook_length
	
	if hook_state == Hook.HOOK:
		$End.global_position = hook_point
		$beam.rotation = ($End.global_position - global_position).angle()
		$beam.region_rect.end.x = $End.position.length()
		$beam.visible = true
		$End/Sprite.visible = true
	else:
		$End/Sprite.visible = false
		$beam.visible = false
	

func ray_cast() -> Vector2:
	
	if ray.is_colliding():
		return ray.get_collision_point()
	return Vector2.INF

func hook(var point : Vector2):
	
	if point == Vector2.INF:
		return
	
	hook_state = Hook.HOOK
	hook_point = point
	
	$End.rotation = ray.get_collision_normal().angle() + PI
	
	start_distance = hook_point.distance_to(global_position)
	
	emit_signal("Hook")

func unhook():
	if hook_state != Hook.HOOK:
		return
	
	hook_state = Hook.IDLE
	
	print(force_dir)
	
	emit_signal("Unhook", direction * force_dir * force)

func move(var velocity : Vector2) -> Vector2:
	
	var hook_v = (hook_point - global_position).normalized()
	
	if hook_v.cross(velocity) > 0:
		direction = hook_v.rotated(PI/2)
	else:
		direction = hook_v.rotated(-PI/2)
	
	if pawn.global_position.distance_to(hook_point) > start_distance:
		pawn.global_position = pawn.global_position.move_toward(hook_point, pawn.global_position.distance_to(hook_point) - start_distance)
	
	return direction * (clamp(direction.dot(velocity) + direction.dot(gravity), -max_speed, max_speed))

