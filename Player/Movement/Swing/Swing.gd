extends MovementComponent

export (float) var hook_length = 40
export (Vector2) var gravity = Vector2(0, 10)
export (float) var max_speed = 200
export (float) var ending_pull_force = 60

onready var ray = $Ray
onready var par = get_parent()

# Hook
var hook_point := Vector2.ZERO
var direction := Vector2.ZERO

var b_active = false
var b_used = false
var b_switch = true

var start_distance = 0

func ray_cast() -> Vector2:
	
	if ray.is_colliding():
		return ray.get_collision_point()
	return Vector2.INF

func _ready():
	pass

func _process(delta):
	ray.cast_to = (get_global_mouse_position() - pawn.global_position).normalized() * hook_length
	
	$Sprite.global_position = hook_point
	
	if b_active:
		switch()

func switch():
	if !b_switch:
		return
	if check_floor_contact():
		if b_used:
			par.to_walk = true
			b_used = false
			prolong_switch()
	if pawn.global_position.distance_to(hook_point) > start_distance:
		if b_used == false:
			par.to_hook = true
			b_used = true
			prolong_switch()
func prolong_switch():
	b_switch = false
	yield(get_tree().create_timer(0.2), "timeout")
	b_switch = true

func check_floor_contact():
	if pawn:
		return pawn.is_on_floor()

func activate():
	b_active = true
	b_used = false
	
	hook_point = ray_cast()
	if hook_point == Vector2.INF:
		print("Coś nie pykło")
	
	start_distance = pawn.global_position.distance_to(hook_point)

# Dalej logika movementComponent

func input():
	if Input.is_action_just_pressed("hook"):
		if ray_cast() != Vector2.INF:
			activate()
	if Input.is_action_just_released("hook"):
		par.to_walk = true

# Called when component is activated
func enter(var vel, var force, var p):
	current_velocity = vel
	current_force = Vector2.ZERO
	pawn = p

# Called when component is desactivated
func leave():
	print("")
	b_active = false
	if direction.x > 0:
		current_force = direction.rotated(-0.5) * ending_pull_force
	else:
		current_force = direction.rotated(0.5) * ending_pull_force

# Movement logic goes here
func move():
	var hook_v = (hook_point - pawn.global_position).normalized()
	
	var correction = (pawn.global_position.distance_to(hook_point) - start_distance) / 1000.0
	if hook_v.cross(current_velocity) > 0:
		direction = hook_v.rotated(PI/2 - correction)
	else:
		direction = hook_v.rotated(-PI/2 + correction)
	current_velocity = direction * (clamp(direction.dot(current_velocity) + direction.dot(gravity), -max_speed, max_speed))

# Collision logic goes here
func update_collision():
	if pawn.is_on_wall():
		current_velocity = Vector2.ZERO
	if pawn.is_on_ceiling():
		current_velocity = Vector2.ZERO
