extends Node2D

enum Direction {
	UP,
	DOWN,
	RIGHT,
	LEFT
}

export (Vector2) var move = Vector2(240, 144)
export (String) var first_level = "res://Levels/Level1.tscn"

var current_scene = null
var next_scene
var current_scene_instance
var next_scene_instance

var player = null
export (PackedScene) var Player

var open_door : Array
var flowers : Array
var b_hook = false

var flower_scenes : Array
var planted_flowers : Array

onready var tween = $Tween

func _ready():
	Events.connect("LoadScene", self, "on_ChangeScene")
	Events.emit_signal("LoadScene", first_level, Direction.UP, 0)
	Events.connect("DoorOpen", self, "on_DoorOpen")
	Events.connect("Flower", self, "on_Flower")
	Events.connect("ChangeHook", self, "on_Hook")

func _input(event):
	
	if Input.is_action_just_pressed("restart"):
		restart()

func on_ChangeScene(scene, direction, spawn_number):
	
	next_scene = load(scene)
	
	next_scene_instance = next_scene.instance()
	if current_scene_instance:
		next_scene_instance.name = current_scene_instance.name + "1"
	
	yield(get_tree(), "idle_frame")
	add_child(next_scene_instance)
	
	next_scene_instance.from = spawn_number
	
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
		
		move_player()
		yield(move_camera(), "completed")
		
		current_scene_instance.free()

	else:
		$Camera2D.position = next_scene_instance.get_camera_position()
	
	current_scene_instance = next_scene_instance
	current_scene = scene
	
	
	if !player:
		restart()
	
	if flower_scenes.has(current_scene):
		get_tree().call_group("Flower", "queue_free")
	
	if open_door.has(current_scene):
		get_tree().call_group("Door", "open")
		
	var i = 0
	for kwiatek in get_tree().get_nodes_in_group("Kwiatki"):
		if planted_flowers.size() > i:
			kwiatek.plant(planted_flowers[i])
			i += 1
		

func on_DoorOpen():
	
	open_door.push_back(current_scene)

func plant_flower():
	
	if flowers.size() == 0:
		return null
	
	var texture = flowers[0]
	flowers.pop_front()
	
	planted_flowers.push_back(texture)
	
	return texture

func on_Flower(flower):
	flowers.push_back(flower)
	flower_scenes.push_back(current_scene)
	player.add_flower(flower)

func on_Hook():
	player.movement.change_hook()
	b_hook = !b_hook

func restart():
	get_tree().call_group("Player", "die")
	
	if player:
		yield(player, "dead")
	
	if Player:
		player = Player.instance()
		
		add_child(player)
		player.name = "player"
		player.position = current_scene_instance.get_restart_point()
		
		if b_hook:
			player.movement.change_hook()
		
		for flower in flowers:
			player.add_flower(flower)

func get_map() -> TileMap:
	if current_scene_instance:
		return current_scene_instance.get_node("TileMap")
	return null

func move_player():
	if player:
		$PlayerTween.interpolate_property(player, "position", player.position, next_scene_instance.get_restart_point(), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$PlayerTween.start()

func move_camera():
#	yield(get_tree(), "idle_frame")
	
	tween.interpolate_property($Camera2D, "position", $Camera2D.position, next_scene_instance.get_camera_position(), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_all_completed")
