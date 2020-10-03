extends Node

class_name MovementComponent
func is_class(name : String): return "MovementComponent" == name || .is_class(name)
func get_class(): return "MovementComponent"

export (float) var move_velocity
export (float) var acceleration_time
export (float) var deceleration_time
export (float) var jump_height
export (float) var jump_time
export (float) var fall_speed

enum Move {
	IDLE,
	STOP,
	START_RIGHT,
	START_LEFT,
	MOVE
}

enum Jump {
	IDLE,
	JUMP,
	FALL
}

var current_velocity : Vector2
var input_axis : Vector2
var move_tween : Node
var move_state = Move.IDLE
var direction_changed := false
var jump_tween : Node
var jump_state = Jump.IDLE
var do_jump = false

# Postać kontrolowana przez ten węzeł
onready var pawn = get_parent()

func _ready():
	# Creates tween for smooth movement
	move_tween = Tween.new()
	add_child(move_tween)
	move_tween.set_owner(get_owner())
	
	jump_tween = Tween.new()
	add_child(jump_tween)
	jump_tween.set_owner(get_owner())
	
	# Checks if parent is moveable or not
	if !pawn.is_class("KinematicBody2D"):
		print("Parent is not moveable")
		set_physics_process(false)

func _input(_event):
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
	
	# Jumping
	if do_jump:
		if jump_state == Jump.IDLE:
			jump()
	else:
		if jump_state == Jump.JUMP:
			fall()
	
	print(move_state)
	
	# Movement
	if direction_changed:
		direction_changed = false
		if input_axis.x == 0:
			stop()
		else:
			start(input_axis.x)
	
	
	pawn.move_and_slide(current_velocity, Vector2(0, -1))
	
	if pawn.is_on_floor():
		jump_state = Jump.IDLE
		current_velocity.y = 0
	elif jump_state == Jump.IDLE:
		fall()

# Starts moving
func start(direction : float):
	
	var state
	if direction == 1:
		state = Move.START_RIGHT
	else:
		state = Move.START_LEFT
	
	move_state = state
	
	move_tween.remove(self, "current_velocity:x")
	move_tween.interpolate_property(self, "current_velocity:x", current_velocity.x, move_velocity * direction, acceleration_time, Tween.TRANS_CIRC, Tween.EASE_OUT)
	move_tween.start()
	
	yield(move_tween, "tween_completed")
	
	
	if move_state == state:
		move_state = Move.MOVE

# Stops character
func stop():
	
	move_state = Move.STOP
	
	move_tween.remove(self, "current_velocity:x")
	move_tween.interpolate_property(self, "current_velocity:x", current_velocity.x, 0, deceleration_time, Tween.TRANS_CIRC, Tween.EASE_IN)
	move_tween.start()
	
	yield(move_tween, "tween_completed")
	
	if move_state == Move.STOP:
		move_state = Move.IDLE

# Start of the jump
func jump():
	
	jump_state = Jump.JUMP
	
	print("Jump")
	
	# Upward in godot is negative
	var initial_velocity = -2.0 * jump_height / jump_time
	print(initial_velocity)
	
	jump_tween.remove(self, "current_velocity:y")
	jump_tween.interpolate_property(self, "current_velocity:y", initial_velocity, 0, jump_time, Tween.TRANS_LINEAR)
	jump_tween.start()
	
	yield(jump_tween, "tween_completed")
	
	print("Done")
	
	if jump_state == Jump.JUMP:
		fall()

func fall():
	
	jump_state = Jump.FALL
	do_jump = false
	
	var fall_velocity = 2.0 * jump_height / jump_time
	
	jump_tween.remove(self, "current_velocity:y")
	jump_tween.interpolate_property(self, "current_velocity:y", current_velocity.y, fall_velocity, jump_time * 3 / 4, Tween.TRANS_LINEAR)
	jump_tween.start()
	
	yield(jump_tween, "tween_completed")
