extends RigidBody2D

class_name Hitable
func is_class(name): return name == "Hitable" || .is_class(name)
func get_class(): return "Hitable"

func _ready():
	pass

func hit(damage, recoil):
	pass
