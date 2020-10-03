extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("change_now", self, "cam_move_handler")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func cam_move_handler(ch):
	position.x += ch[0]
	position.y += ch[1]
