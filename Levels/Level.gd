extends Node2D


export (PackedScene) var Player
export (Array, NodePath) var restart_points

var from = 0
var player = null
var old_player = null

# Called when the node enters the scene tree for the first time.
func _ready():
#	restart()
	
	yield(get_tree().create_timer(1.0), "timeout")
	
	get_tree().call_group("Exit", "enable")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func get_restart_point():
	
	return get_node(restart_points[from]).global_position

func get_camera_position():
	return $CameraPosition.global_position

