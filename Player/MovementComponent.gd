extends Node

class_name MovementComponent
func is_class(name : String): return "MovementComponent" == name || .is_class(name)
func get_class(): return "MovementComponent"

signal idle
signal move
signal jump
signal fall
signal land_straight
signal land_direction
signal ceiling
signal wall

enum Move {
	IDLE,
	STOP,
	START_RIGHT,
	START_LEFT,
	MOVE
}

enum Jump {
	IDLE = 5,
	JUMP = 6,
	FALL = 7
}

export (float) var move_velocity
export (float) var acceleration_time
export (float) var deceleration_time
export (float) var jump_height
export (float) var jump_time
export (float) var force_time

# Movement
var current_velocity : Vector2
var input_axis : Vector2
onready var move_tween = $move
var move_state = Move.IDLE
var direction_changed := false

onready var force_tween = $force
var current_force := Vector2.ZERO
var dying = false

# Jumping
onready var jump_tween = $jump
var jump_state = Jump.IDLE
var do_jump = false

# Postać kontrolowana przez ten węzeł
onready var pawn = get_parent()

func _ready():
	
	# Checks if parent is moveable or not
	if !pawn.is_class("KinematicBody2D"):
		print("Parent is not moveable")
		set_physics_process(false)

# Żeby można było zmieniać
func _input(_event):
	input()

func input():
	var last = input_axis
	input_axis = Vector2(0, 0)
	if Input.is_action_pressed("right"):
		input_axis.x += 1
	if Input.is_action_pressed("left"):
		input_axis.x -= 1
	if Input.is_action_just_pressed("jump"):
		do_jump = true
	if Input.is_action_just_released("jump"):
		do_jump = false
	if last.x != input_axis.x:
		direction_changed = true

func _physics_process(_delta):
	
	move()
	
	pawn.move_and_slide(current_velocity + current_force, Vector2(0, -1))
	
	update_collision()

func _on_hook():
	force_tween.remove_all()
	current_force = Vector2.ZERO
	move_state = Move.IDLE
	jump_state = Jump.IDLE

func _on_unhook(var force):
	apply_force(force)
	move_state = Move.IDLE
	direction_changed = true
	jump_state = Jump.IDLE

# Emits signals with state info
func change_state(new_state):
	match new_state:
		Jump.JUMP:
			jump_state = Jump.JUMP
			emit_signal("jump")
		Jump.FALL:
			jump_state = Jump.FALL
			emit_signal("fall")
		Jump.IDLE:
			jump_state = Jump.IDLE
			if move_state == Move.IDLE or move_state == Move.STOP:
				emit_signal("land_straight")
			else:
				emit_signal("land_direction", input_axis.x)
	
	match new_state:
		Move.IDLE:
			move_state = Move.IDLE
			emit_signal("idle")
		Move.START_LEFT: 
			move_state = Move.START_LEFT
			emit_signal("move", input_axis.x)
		Move.START_RIGHT: 
			move_state = Move.START_RIGHT
			emit_signal("move", input_axis.x)
		Move.STOP:
			move_state = Move.STOP
		Move.MOVE:
			move_state = Move.MOVE
		_: continue
		

func update_collision():

	if pawn.is_on_floor():
		if jump_state != Jump.IDLE:
			change_state(Jump.IDLE)
			
			current_velocity.y = 5
			
			force_tween.remove_all()
			current_force = Vector2.ZERO
			

	elif jump_state == Jump.IDLE:
		fall()
	
	if pawn.is_on_wall():
		force_tween.remove_all()
		current_force = Vector2.ZERO
	
	if pawn.is_on_ceiling():
		current_velocity.y = 0
		fall()

func apply_force(var force : Vector2, time = jump_time * 2):
	
	current_force = force
	
	force_tween.interpolate_property (
		self,
		"current_force",
		current_force, 
		Vector2.ZERO,
		time, 
		Tween.TRANS_CUBIC,
		Tween.EASE_IN )
	force_tween.start()

func move():
	
	# Jumping
	if do_jump: 
		if jump_state == Jump.IDLE:
			jump()
	elif jump_state == Jump.JUMP:
		fall()
	
	# Movement
	if direction_changed:
		direction_changed = false
		if input_axis.x == 0:
			stop()
		else:
			start(input_axis.x)

# Starts moving
func start(direction : float):
	
	if direction == 1:
		change_state(Move.START_RIGHT)
	else:
		change_state(Move.START_LEFT)
	
	var prev_state = move_state
	
	move_tween.remove_all()
	move_tween.interpolate_property (
		self,
		"current_velocity:x",
		current_velocity.x,
		move_velocity * direction,
		acceleration_time,
		Tween.TRANS_CIRC,
		Tween.EASE_OUT )
	move_tween.start()
	
	yield(move_tween, "tween_completed")
	
	if move_state == prev_state:
		change_state(Move.MOVE)

# Stops character
func stop():
	
	change_state(Move.STOP)
	
	move_tween.remove_all()
	move_tween.interpolate_property (
		self,
		"current_velocity:x",
		current_velocity.x,
		0,
		deceleration_time,
		Tween.TRANS_CIRC,
		Tween.EASE_IN )
	move_tween.start()
	
	yield(move_tween, "tween_completed")
	
	if move_state == Move.STOP:
		change_state(Move.IDLE)

# Start of the jump
func jump():
	
	change_state(Jump.JUMP)
	
	# Upward in godot is negative
	var initial_velocity = -2.0 * jump_height / jump_time
	
	jump_tween.remove_all()
	jump_tween.interpolate_property (
		self,
		"current_velocity:y",
		initial_velocity,
		0,
		jump_time,
		Tween.TRANS_LINEAR )
	jump_tween.start()
	
	yield(jump_tween, "tween_completed")
	
	if jump_state == Jump.JUMP:
		do_jump = false
		fall()

func fall():
	
	change_state(Jump.FALL)
	
	var fall_velocity = 2.0 * jump_height / jump_time
	
	jump_tween.remove_all()
	jump_tween.interpolate_property (
		self,
		"current_velocity:y",
		current_velocity.y / 2,
		fall_velocity,
		jump_time,
		Tween.TRANS_LINEAR )
	jump_tween.start()
	
	yield(jump_tween, "tween_completed")
