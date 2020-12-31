extends Area2D

enum Type {
	NearestPoint
	ExactSpot
}

enum Direction {
	Up
	Down
	Left
	Right
}

export (Type) var transition_type
export (Direction) var dir
export (String) var next_level

func _ready():
	enable()

func enable():
	yield(get_tree().create_timer(0.5), "timeout")
	set_deferred("monitoring", true)
	


func _on_player_entered(body):
	
	if next_level == "":
		print("Nie ma poziomu:")
		print(self)
		return
	set_deferred("monitoring", false)
	var a = Vector2.ZERO
	match dir:
		Direction.Up:
			a = Vector2(0, -1)
		Direction.Down:
			a = Vector2(0, 1)
		Direction.Left:
			a = Vector2(-1, 0)
		Direction.Right:
			a = Vector2(1, 0)
	Events.emit_signal("MoveCamera", next_level, transition_type, a)
