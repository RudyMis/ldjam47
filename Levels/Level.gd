extends Node2D


export (PackedScene) var Player

var player = null
var old_player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	restart()

func _input(event):
	
	if Input.is_action_just_pressed("restart"):
		restart()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func restart():
	
	if player:
		player.call_deferred("queue_free")
		yield(get_tree().create_timer(0.5), "timeout")
	
	if Player:
		player = Player.instance()
		
		add_child(player)
		player.position = $PlayerStart.position
		
