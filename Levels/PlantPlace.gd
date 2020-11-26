extends Area2D

var b_ma_kwiatek = false

func _ready():
	pass

func plant(texture):
	b_ma_kwiatek = true
		
	if $Sprite.texture == null:
		$Sprite.texture = texture
	
	else:
		var prev = $Sprite.texture
		$Sprite.texture = texture
		Events.emit_signal("Flower", prev)

func _on_Area2D_body_entered(body):
	if "movement" in body:
		var flower = body.plant_flower()
		if flower == null:
			return
		plant(flower)
		
		