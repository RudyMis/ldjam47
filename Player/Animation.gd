extends Sprite

class_name AnimationComponent
func is_class(name : String): return "AnimationComponent" == name || .is_class(name)
func get_class(): return "AnimationComponent"

var signal_emiter = null
var q : Array
onready var state_machine = $AnimationTree.get("parameters/playback")

func _ready():
	if find_movement_node():
		signals()

func find_movement_node():
	for child in get_parent().get_children():
		if child.is_class("MovementComponent"):
			signal_emiter = child
			return true
	
	print("No movement component attached to parent")
	set_process(false)
	return false

func signals():
	signal_emiter.connect("idle", self, "_idle")
	signal_emiter.connect("move", self, "_move")
	signal_emiter.connect("jump", self, "_jump")
	signal_emiter.connect("fall", self, "_fall")
	signal_emiter.connect("land_straight", self, "_land_idle")
	signal_emiter.connect("land_direction", self, "_land_move")

func _idle():
	state_machine.travel("Idle")

func _move(direction : int):
	state_machine.travel("Move")
	set_flip_h(direction < 0)

func _jump():
	state_machine.travel("Jump")

func _fall():
	match state_machine.get_current_node():
		"Move":
			state_machine.travel("Fall_Edge")
		"Jump":
			state_machine.travel("Fall")

func _land_idle():
	state_machine.travel("Idle")

func _land_move(direction : int):
	state_machine.travel("Move")
	set_flip_h(direction < 0)
