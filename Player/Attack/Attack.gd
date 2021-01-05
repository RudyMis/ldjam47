extends Area2D

signal attack
signal end_combo

export (int) var number_of_attacks = 2
export (Array, float) var cooldown = [0.2, 0.4]
export (Array, float) var damage = [50.0, 60.0]
export (Array, Vector2) var recoil = [Vector2(20.0, -10.0), Vector2(40.0, -50.0)]
export (float) var combo_reset_time = 0.5
export (float) var scan_time = 0.05
export (float) var anticipation_time = 0.1

export (NodePath) var p_pawn
onready var pawn = get_node_or_null(p_pawn)

var do_attack = false
var can_attack = true
var combo = 0

func _ready():
	if pawn == null:
		set_process(false)

func _input(event):
	if Input.is_action_just_pressed("attack"):
		do_attack = true
	if !Input.is_action_pressed("attack"):
		do_attack = false

func _process(delta):
	
	if do_attack and can_attack:
		chain_attack()
		do_attack = false

func _on_hit(body):
	if body.is_class("Hitable"):
		body.hit(damage[combo], recoil[combo])
		inc_combo()

func inc_combo():
	combo += 1
	if combo == number_of_attacks:
		reset_combo()

func reset_combo(): 
	combo = 0
	print("Tu")
	emit_signal("end_combo")
	
func chain_attack():
	var last_combo = combo + 1
	attack()
	yield(get_tree().create_timer(combo_reset_time), "timeout")
	if last_combo >= combo:
		reset_combo()

func attack():
	emit_signal("attack")
	enable_collision()
	can_attack = false
	yield(get_tree().create_timer(cooldown[combo]), "timeout")
	can_attack = true

# Będzie odpalane rzadziej, niż attack, więc nie ma problemu z yieldem
func enable_collision():
	yield(get_tree().create_timer(anticipation_time), "timeout")
	monitoring = true
	yield(get_tree().create_timer(scan_time), "timeout")
	monitoring = false
