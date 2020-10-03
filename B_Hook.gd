extends Node2D

signal Hook
signal Unhook

export (float) var hook_length = 200
export (Vector2) var gravity = Vector2(0, 100)
export (NodePath) var debug_path


onready var ray = $RayCast2D

enum Hook {
	IDLE,
	HOOK
}

onready var pawn = get_parent()

onready var debug_draw = get_node(debug_path)

# Hook
var hook_point
var hook_state = Hook.IDLE

func _ready():
	pass # Replace with function body.

func _input(event):
	
	if Input.is_action_just_pressed("hook"):
		var pos = ray_cast()
		if pos != Vector2.INF:
			hook(pos)
	if Input.is_action_just_released("hook"):
		unhook()

func _physics_process(delta):
	
	ray.cast_to = (get_global_mouse_position() - pawn.position).normalized() * hook_length
	
	#debug_draw.position = ray.cast_to + pawn.position
	
	if ray.is_colliding():
		$End.global_position = ray.get_collision_point()
		$"End/CPUParticles2D".visible=true
	else:
		$End.global_position=ray.cast_to
		$"End/CPUParticles2D".visible=false
	$beam.rotation=ray.cast_to.angle()
	$beam.region_rect.end.x=$End.position.length()

func ray_cast() -> Vector2:
	
	if ray.is_colliding():
		return ray.get_collision_point()
	return Vector2.INF

func hook(var point : Vector2):
	
	hook_state = Hook.HOOK
	hook_point = point
	
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
	
	return direction * (velocity.length() + direction.dot(gravity))