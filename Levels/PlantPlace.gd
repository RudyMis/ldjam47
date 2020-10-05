extends Area2D

func _ready():
	pass

func _on_Area2D_body_entered(body):
	if "movement" in body:
		var flower = body.plant_flower()
		if flower == null:
			return

		if $Sprite.texture == null:
			$Sprite.texture = flower
		
		else:
			var texture = $Sprite.texture
			$Sprite.texture = flower
			Events.emit_signal("Flower", texture)
