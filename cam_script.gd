extends Camera2D

var time = 0.5
var t = 0
var movement = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if movement != Vector2(0, 0):
		if (t < time):
			t += delta
			position += movement * delta / time 
		else:
			movement = Vector2(0, 0)

func cam_move_handler(ch):
	movement = ch
	t = 0
