extends Node2D

func _ready():
	pass

func _process(delta):
	
	for child in get_children():
		if !child.b_ma_kwiatek:
			return
	
	 Events.emit_signal("LoadScene", "res://Levels/End.tscn", 0)
