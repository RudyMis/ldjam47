extends Sprite

class_name AnimationComponent
func is_class(name : String): return "AnimationComponent" == name || .is_class(name)
func get_class(): return "AnimationComponent"

export (NodePath) var movement
var q : Array
onready var state_machine = $AnimationTree.get("parameters/playback")

func _ready():
	movement = get_node_or_null(movement)
	if movement:
		signals()

func signals():
	movement.connect("idle", self, "_idle")
	movement.connect("move", self, "_move")
	movement.connect("jump", self, "_jump")
	movement.connect("fall", self, "_fall")
	movement.connect("land_straight", self, "_land_idle")
	movement.connect("land_direction", self, "_land_move")

func _idle():
	match state_machine.get_current_node():
		"Fall":
			pass
		"Fall_Edge":
			pass
		_:
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
