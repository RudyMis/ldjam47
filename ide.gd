extends AudioStreamPlayer2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)

var graj=0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $"../AnimatedSprite".animation=="run" && graj==0:
		graj=1
		play()
	if $"../AnimatedSprite".animation!="run" && graj==1:
		graj=0
		stop()
