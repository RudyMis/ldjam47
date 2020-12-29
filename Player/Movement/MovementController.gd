extends Node

signal idle
signal move
signal jump
signal fall
signal land_straight
signal land_direction
signal ceiling
signal wall

export (Array, NodePath) var nodes = []
export (NodePath) var default

export (Array) var switches = [
]

var p_current_node

var to_hook = false
var to_walk = false

# Wartości zmieniane przez dzieci głównie
var current_velocity := Vector2()
var current_force := Vector2()
onready var pawn = get_parent()

func _ready():
	if !is_parent_kinematic():
		return
	
	for p_node in nodes:
		turn_node(p_node, false)
	turn_node(default, true)
	p_current_node = default
	
	setup_movement_component(
		get_node(p_current_node),
		Vector2(0, 0), 
		Vector2(0, 0)
	)

func _process(delta):
	var switch = check_for_movement_change()
	if switch != null:
		change_movement_type(switch[0], switch[2])

func _physics_process(delta):
	
	var current_node = get_node(p_current_node)
	
	current_node.move()
	
	pawn.move_and_slide(current_node.current_velocity + current_node.current_force, Vector2(0, -1))
	
	current_node.update_collision()

func is_parent_kinematic():
	if !pawn.is_class("KinematicBody2D"):
		print("Rodzic nie jest poruszalnym bytem (oczekuję KinematicBody2D)")
		set_process(false)
		return false
	return true


func check_for_movement_change():
	for switch in switches:
		if switch[0] == p_current_node and get(switch[1]):
			return switch
	return null

func setup_movement_component(
	var node : MovementComponent,
	var vel : Vector2,
	var force : Vector2
):
	node.enter(vel, force, pawn)

func change_movement_type(var from : NodePath, var to : NodePath):
	turn_node(from, false)
	turn_node(to, true)
	p_current_node = to
	var prev_node = get_node(from)
	var current_node = get_node(to)
	if prev_node and current_node:
		prev_node.leave()
		setup_movement_component(current_node, prev_node.current_velocity, prev_node.current_force)

func turn_node(var p_node, var b_to):
	var node = get_node(p_node)
	if !node:
		print("Null pointer: ")
		print(p_node)
	if node.is_class("Node2D"): node.set_visible(b_to)
