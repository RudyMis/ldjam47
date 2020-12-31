extends Node2D

class_name MovementComponent
func is_class(name : String): return "MovementComponent" == name || .is_class(name)
func get_class(): return "MovementComponent"

var current_velocity : Vector2
var current_force : Vector2
onready var pawn = get_parent()

func _ready():
	pass

# Żeby można było zmieniać
func _input(_event):
	input()

func input():
	pass

func check():
	return true

func enter(var vel, var force, var p):
	pass

func leave():
	pass

func move():
	pass

func update_collision():
	pass
