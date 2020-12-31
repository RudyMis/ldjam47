extends Hitable

class_name Enemy
func is_class(name): return name == "Enemy" || .is_class(name)
func get_class(): return "Enemy"

export (float) var max_health = 100.0

export (NodePath) var p_anim_player
onready var anim_player = get_node_or_null(p_anim_player)

var health = max_health

func _ready():
	pass

func hit(damage, recoil):
	
	print("ała")
	
	health -= damage
	
	if anim_player:
		anim_player.play("Hit")
	
	apply_central_impulse(recoil)
