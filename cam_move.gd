extends Line2D

export var change = Vector2(0, 0) # When passing from black to white, change will happen. When passing from white to black, opposite change will happen.
export var visibility = 0 # Debugging.
var last_contact = "";

signal change_now(ch)

func _ready():
	visible = visibility;
	connect("change_now", get_parent().get_parent().get_node("Camera2D"), "cam_move_handler")

func _process(delta):
	#if ($left_det.get_overlapping_bodies() != [] || $right_det.get_overlapping_bodies() != []):
	#	print($left_det.get_overlapping_bodies())
	#	print($right_det.get_overlapping_bodies())
	#	print("")
	if ($det_B.get_overlapping_bodies() != []): # touches black
		if (last_contact == "W"):
			emit_signal("change_now", change * -1)
		last_contact = "B"
	if ($det_W.get_overlapping_bodies() != []): # toucheds white
		if (last_contact == "B"):
			emit_signal("change_now", change)
		last_contact = "W"
