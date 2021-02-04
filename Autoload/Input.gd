extends Node

enum {
	KEYBOARD,
	CONTROLLER
}

var device_type := KEYBOARD
var deadzone = 0.5

func _ready():
	if len(Input.get_connected_joypads()) > 0:
		print("Podłączono kontroler")
		device_type = CONTROLLER

func get_controller_axis():
	pass
