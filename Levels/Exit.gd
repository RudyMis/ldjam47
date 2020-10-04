extends Area2D

enum Direction {
	UP,
	DOWN,
	RIGHT,
	LEFT
}

export (String) var next
export (Direction) var direction

func _ready():
	pass

func enable():
	
	monitoring = true

func _on_Exit(body):
	if next != "":
		
		Events.emit_signal("LoadScene", next, direction)
		
