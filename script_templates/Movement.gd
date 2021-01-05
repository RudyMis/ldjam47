extends MovementComponent


func _ready():
	pass

func input():
	pass

# Sprawdzenie, czy można aktualnie na to zmienić
func check():
	return true

# Called when component is activated
func enter(var vel, var force, var p):
	pass

# Called when component is desactivated
func leave():
	pass

# Movement logic goes here
# Change current_velocity and current_force; don't move the pawn itself
func move():
	pass

# Collision logic goes here
func update_collision():
	pass
