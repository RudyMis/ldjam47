extends TileMap

export (String) var data_name = ""

export (int) var env_bit = 1

func _ready():
	var data = Data.load_temp(data_name)
	if data == null:
		Data.save_temp(data_name, 0)
		data = 0

	var color_value = (0.5 + data / 2)
	set_modulate(Color(color_value, color_value, color_value, 1))
	set_collision_layer_bit(env_bit, bool(data))
