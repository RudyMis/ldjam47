extends AudioStreamPlayer2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var graj=0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $"../Sprite".animation=="run" && graj==0:
		graj=1
		play()
	if $"../Sprite".animation!="run" && graj==1:
		graj=0
		stop()
