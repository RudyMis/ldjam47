extends Node2D

export (PackedScene) var PlayerScene
export (PackedScene) var first_level
export (float) var t_transition = 0.3

onready var cam = $Camera2D
onready var cam_tween = $CameraTween
var current_level

var player = null

var data : Dictionary

func _ready():
	if first_level:
		Events.connect("MoveCamera", self, "_move_camera")
		current_level = first_level.instance()
		add_child(current_level)
		start()

func _process(delta):
	pass

func _move_camera(level : String, trans_type : int, direction : Vector2):
	player.set_movement(false)
	
	var next_level = load(level).instance()
	yield(get_tree(), "idle_frame")
	add_child(next_level)
	next_level.set_position(current_level.position + direction * get_viewport().size)
	
	cam_tween.interpolate_property(
		cam,
		"position",
		cam.position,
		next_level.get_camera_position(),
		t_transition,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT
	)
	match trans_type:
		0:
			cam_tween.interpolate_property(
				player,
				"position",
				player.position,
				next_level.get_nearest_point(player.position),
				t_transition,
				Tween.TRANS_LINEAR
			)
		1:
			next_level.get_nearest_point(player.position)
	cam_tween.start()
	yield(cam_tween, "tween_all_completed")
	
	current_level.queue_free()
	current_level = next_level
	next_level = null
	
	player.set_movement(true)

func restart():
	exit()
	start()

func exit():
	pass

func start():
	cam.position = current_level.get_camera_position()
	player = PlayerScene.instance()
	var start = current_level.get_node_or_null("start")
	if start:
		player.position = start.global_position
	else:
		player.position = current_level.get_nearest_point(player.position)
	add_child(player)
