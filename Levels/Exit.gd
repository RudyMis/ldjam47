extends Area2D

enum Direction {
	UP,
	DOWN,
	RIGHT,
	LEFT
}

export (String) var next
export (int) var spawn_number = 0
export (Direction) var direction

func _ready():
	pass

func enable():
	print("Plum")
	monitoring = true

func _on_Exit(body):
	if next != "":
		
		Events.emit_signal("LoadScene", next, direction, spawn_number)
		
