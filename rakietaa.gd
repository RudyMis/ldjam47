extends "res://Player/B_Hook.gd"

var kierunek = 0

func _ready():
	pass # Replace with function body.


func hook(var point : Vector2):
	
	hook_state = Hook.HOOK
	
	emit_signal("Hook")

func move(var velocity : Vector2) -> Vector2:
	
	kierunek = $End.position.normalized()
	
	if ray_cast() != Vector2.INF:
		unhook()
	
	return kierunek * max_speed
