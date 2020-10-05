extends Node2D

func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		get_tree().change_scene("res://Game.tscn")
	if Input.is_action_pressed("ui_cancel"):
		$credits.visible = true
