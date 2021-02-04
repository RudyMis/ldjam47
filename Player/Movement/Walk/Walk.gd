extends MovementComponent

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

export (float) var move_velocity = 75.0
export (float) var acceleration_time = 0.3
export (float) var deceleration_time = 0.1
export (float) var jump_height = 24.0
export (float) var jump_time = 0.25
export (float) var force_time 

# Movement
var input_axis : Vector2
onready var move_tween = $move
var move_state = Move.IDLE
var direction_changed := false
onready var force_tween = $force

# Jumping
onready var jump_tween = $jump
var jump_state = Jump.IDLE
var do_jump = false

func _ready():
	pass

func input():
	var last = input_axis
	input_axis = Vector2(0, 0)
	input_axis.x = sign(Input.get_action_strength("right") - Input.get_action_strength("left"))
	if Input.is_action_just_pressed("jump"):
		do_jump = true
	if Input.is_action_just_released("jump"):
		do_jump = false
	if sign(last.x) != sign(input_axis.x):
		direction_changed = true

func enter(var vel, var force, var p):
	move_state = Move.IDLE
	jump_state = Jump.IDLE
	current_velocity = vel
	apply_force(force)
	pawn = p
	direction_changed = true

func leave():
	move_tween.remove_all()
	jump_tween.remove_all()
	force_tween.remove_all()

# Emits signals with state info
func change_state(new_state):
	var p = get_parent()
	match new_state:
		Jump.JUMP:
			jump_state = Jump.JUMP
			p.emit_signal("jump")
		Jump.FALL:
			jump_state = Jump.FALL
			p.emit_signal("fall")
		Jump.IDLE:
			jump_state = Jump.IDLE
			if move_state == Move.IDLE or move_state == Move.STOP:
				p.emit_signal("land_straight")
			else:
				p.emit_signal("land_direction", input_axis.x)
	
		Move.IDLE:
			move_state = Move.IDLE
			p.emit_signal("idle")
		Move.START_LEFT: 
			move_state = Move.START_LEFT
			p.emit_signal("move", input_axis.x)
		Move.START_RIGHT: 
			move_state = Move.START_RIGHT
			p.emit_signal("move", input_axis.x)
		Move.STOP:
			move_state = Move.STOP
		Move.MOVE:
			move_state = Move.MOVE
		_: continue
		

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

# Starts moving
func start(direction : float, acc_time = acceleration_time):
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
		acc_time,
		Tween.TRANS_CIRC,
		Tween.EASE_OUT )
	move_tween.start()
	yield(move_tween, "tween_completed")
	if move_state == prev_state:
		change_state(Move.MOVE)

# Stops character
func stop(dece_time = deceleration_time):
	change_state(Move.STOP)
	move_tween.remove_all()
	move_tween.interpolate_property (
		self,
		"current_velocity:x",
		current_velocity.x,
		0,
		dece_time,
		Tween.TRANS_CIRC,
		Tween.EASE_IN )
	move_tween.start()
	yield(move_tween, "tween_completed")
	if move_state == Move.STOP:
		change_state(Move.IDLE)

# Start of the jump
func jump():
	change_state(Jump.JUMP)
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
