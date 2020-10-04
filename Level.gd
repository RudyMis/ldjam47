extends Node2D


export (PackedScene) var Player

var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	restart()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func restart():
	if player:
		player.queue_free()
	if Player:
		player = Player.instance()
		add_child(player)
		player.position = $PlayerStart.position
