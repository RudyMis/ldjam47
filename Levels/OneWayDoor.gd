extends Area2D

func _ready():
	pass

func open():
	yield(get_tree().create_timer(0.5), "timeout")
	$Door.set_collision_layer(0)
	$Sprite.hide()
	

func _on_Area2D_body_entered(body):
	print(body)
	if "movement" in body:
		Events.emit_signal("DoorOpen")
		open()
