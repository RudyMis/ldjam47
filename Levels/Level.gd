extends Node2D

export (NodePath) var exits

var start_position := Vector2.ZERO
var player = null
var old_player = null
var restart_points : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	exits = get_node(exits)
	get_restart_points()

func get_restart_points():
	for child in exits.get_children():
		restart_points.push_back(child)

func get_nearest_point(pos : Vector2):
	if restart_points.size() < 1:
		return Vector2.INF
	var best = restart_points[0]
	for p in restart_points:
		if pos.distance_squared_to(p.global_position) < pos.distance_squared_to(best.global_position):
			best = p
	start_position = best.global_position
	return best.global_position

func get_current_restart():
	return start_position

func get_camera_position():
	return $CameraPosition.global_position

