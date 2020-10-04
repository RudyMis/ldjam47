extends Node

func _ready():
	pass
	
func change_scene(path):
	var loader = ResourceLoader.load_interactive(path)
	if !loader:
		return
	set_process(true)
