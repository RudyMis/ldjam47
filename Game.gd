extends Node2D

enum Direction {
	UP,
	DOWN,
	RIGHT,
	LEFT
}

export (Vector2) var move = Vector2(240, 144)
export (TileSet) var tileset

var current_scene = null
var next_scene
var current_scene_instance
var next_scene_instance

onready var tween = $Tween

func _ready():
	Events.connect("LoadScene", self, "on_ChangeScene")
	Events.emit_signal("LoadScene", "res://Levels/Level1.tscn", Direction.UP)
	
func _process(delta):
	$Sprite.position = get_global_mouse_position()

func on_ChangeScene(scene, direction):
	
	next_scene = load(scene)
	
	next_scene_instance = next_scene.instance()
	if current_scene_instance:
		next_scene_instance.name = current_scene_instance.name + "1"
	
	yield(get_tree(), "idle_frame")
	add_child(next_scene_instance)
	
	if current_scene_instance:
		
		match direction:
			Direction.UP:
				next_scene_instance.position = current_scene_instance.position + Vector2(0, -move.y)
			Direction.DOWN:
				next_scene_instance.position = current_scene_instance.position + Vector2(0, move.y)
			Direction.RIGHT:
				next_scene_instance.position = current_scene_instance.position + Vector2(move.x, 0)
			Direction.LEFT:
				next_scene_instance.position = current_scene_instance.position + Vector2(-move.x, 0)
				
		yield(move_camera(), "completed")
	
		current_scene_instance.free()
	else:
		$Camera2D.position = next_scene_instance.get_camera_position()
	
	current_scene_instance = next_scene_instance
	
	current_scene_instance.restart()

func move_camera():
#	yield(get_tree(), "idle_frame")
	
	
	tween.interpolate_property($Camera2D, "position", $Camera2D.position, next_scene_instance.get_camera_position(), 0.5, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_all_completed")
