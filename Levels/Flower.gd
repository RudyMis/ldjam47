extends Sprite

export (bool) var pickable = true

func _ready():
	pass


func _on_Area2D_body_entered(body):
	
	if pickable:
		Events.emit_signal("Flower", texture)
	
		queue_free()
