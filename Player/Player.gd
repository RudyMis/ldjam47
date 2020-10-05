extends KinematicBody2D

signal dead

onready var movement = $MovementComponent

var map  = null

func _ready():
	Events.connect("LoadScene", self, "on_loadScene")

func _process(delta):
	# Kolce
	if !map:
		if get_parent():
			map = get_parent().get_map()
	else:
		
		var cell_pos = Array()
		
		if is_on_floor():
			cell_pos.push_back(map.world_to_map(global_position - map.global_position))
		if is_on_ceiling():
			cell_pos.push_back(map.world_to_map(global_position - map.global_position) + Vector2(0, -1))
		if is_on_wall():
			cell_pos.push_back(map.world_to_map(global_position - map.global_position) + Vector2(0, -1))
			cell_pos.push_back(map.world_to_map(global_position - map.global_position))
		
		for pos in cell_pos:
			var cell = map.get_cellv(pos)
			if cell == 6:
				mark_dead()
				return
		
		

func on_loadScene(scene, direction, spawn_number):
	map = null

func mark_dead():
	get_parent().restart()
	hide()
	set_process(false)

func die():
	
	movement.dying = true
	
	yield(get_tree().create_timer(0.6), "timeout")
	
	emit_signal("dead")
	
	queue_free()

