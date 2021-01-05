extends Node

var data := Dictionary()

func _ready():
	pass

func save_temp(name : String, value):
	data[name] = value

func load_temp(name):
	if data.has(name):
		return data[name]
	return null
