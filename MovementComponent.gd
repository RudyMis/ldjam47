extends Node

class_name MovementComponent
func is_class(name : String): return "MovementComponent" == name || .is_class(name)
func get_class(): return "MovementComponent"

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

export (float) var move_velocity
export (float) var acceleration_time
export (float) var deceleration_time
export (float) var jump_height
export (float) var jump_time
export (float) var force_time

export (NodePath) var hook_path
export (NodePath) var sprite_path

# Movement
var current_velocity : Vector2
var input_axis : Vector2
var move_tween : Node
var move_state = Move.IDLE
var direction_changed := false
var current_force := Vector2.ZERO


# Jumping
var jump_tween : Node
var jump_state = Jump.IDLE
var do_jump = false

var b_hook = false
onready var hook = get_node(hook_path)

# Postać kontrolowana przez ten węzeł
onready var pawn = get_parent()
onready var sprite = get_node(sprite_path)



func _ready():
	# Creates tween for smooth movement
	move_tween = Tween.new()
	add_child(move_tween)
	move_tween.set_owner(get_owner())
	
	jump_tween = Tween.new()
	add_child(jump_tween)
	jump_tween.set_owner(get_owner())
	
	hook.connect("Hook", self, "_on_hook")
	hook.connect("Unhook", self, "_on_unhook")
	
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
	
	if b_hook:
		 current_velocity = hook.move(current_velocity)
	else:
		move()
	
	pawn.move_and_slide(current_velocity + current_force, Vector2(0, -1))
	
	if !b_hook:
		collision()

func _on_hook():
	sprite.animation = "hook"
	b_hook = true

func _on_unhook():
	apply_force(Vector2(current_velocity.x / 2, current_velocity.y))
	move_state = Move.IDLE
	direction_changed = true
	jump_state = Jump.IDLE
	b_hook = false

func apply_force(var force : Vector2):
	
	current_force = force
	
	yield(get_tree().create_timer(force_time), "timeout")
	
	current_force = Vector2.ZERO

func move():
	# Jumping
	if do_jump:
		if jump_state == Jump.IDLE:
			jump()
	else:
		if jump_state == Jump.JUMP:
			fall()
	
	# Movement
	if direction_changed:
		direction_changed = false
		if input_axis.x == 0:
			stop()
		else:
			start(input_axis.x)

func collision():
	
	if pawn.is_on_floor():
		if jump_state != Jump.IDLE:
			jump_state = Jump.IDLE
			current_velocity.y = 5
			current_force = Vector2.ZERO
			sprite.animation = "land"
			yield(sprite, "animation_finished")
			if sprite.animation == "land":
				sprite.animation = "idle"

	#elif pawn.is_on_wall():
	#	jump_state = Jump.IDLE
	
	elif jump_state == Jump.IDLE:
		fall()
		

# Starts moving
func start(direction : float):
	
	sprite.animation = "run"
	var state
	if direction == 1:
		sprite.flip_h = false
		state = Move.START_RIGHT
	else:
		sprite.flip_h = true
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
		sprite.animation = "idle"

# Start of the jump
func jump():
	
	jump_state = Jump.JUMP
	sprite.animation = "jump"
	
	# Upward in godot is negative
	var initial_velocity = -2.0 * jump_height / jump_time
	
	jump_tween.remove(self, "current_velocity:y")
	jump_tween.interpolate_property(self, "current_velocity:y", initial_velocity, 0, jump_time, Tween.TRANS_LINEAR)
	jump_tween.start()
	
	yield(jump_tween, "tween_completed")
	
	if jump_state == Jump.JUMP:
		fall()

func fall():
	
	jump_state = Jump.FALL
	sprite.animation = "fall"
	do_jump = false
	
	var fall_velocity = 2.0 * jump_height / jump_time
	
	jump_tween.remove(self, "current_velocity:y")
	jump_tween.interpolate_property(self, "current_velocity:y", current_velocity.y / 2, fall_velocity, jump_time * 3 / 4, Tween.TRANS_LINEAR)
	jump_tween.start()
	
	yield(jump_tween, "tween_completed")
