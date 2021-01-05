extends Node2D

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

export (Array) var switches = []

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
	
	switches = [
		[nodes[0], "to_hook", nodes[1]],
		[nodes[1], "to_walk", nodes[0]]
	]
	
	for p_node in nodes:
		turn_node(p_node, false)
	turn_node(default, true)
	p_current_node = default
	
	get_node(p_current_node).enter(
		Vector2(0, 0), 
		Vector2(0, 0),
		pawn
	)

func _process(delta):
	var switch = check_for_movement_change()
	if switch != null:
		change_movement_type(switch[0], switch[2])

func _input(_event):
	if Input.is_action_just_pressed("hook"):
		to_hook = true
	if Input.is_action_just_released("hook") && p_current_node != default:
		to_walk = true

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
			set(switch[1], false)
			return switch
	return null

func change_movement_type(var from : NodePath, var to : NodePath):
	turn_node(from, false)
	turn_node(to, true)
	var prev = get_node(from)
	var next = get_node(to)
	if prev and next:
		if next.check(): 
			prev.leave()
			next.enter(prev.current_velocity, prev.current_force, pawn)
			p_current_node = to

func turn_node(var p_node, var b_to):
	var node = get_node(p_node)
	if !node:
		print("Null pointer: ")
		print(p_node)
	if node.is_class("Node2D"): node.set_visible(b_to)
