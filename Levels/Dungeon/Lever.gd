extends Hitable

enum {
	OFF
	ON
}

export (NodePath) var sprite
export (String) var data_name = ""

var state = OFF

func _ready():
	sprite = get_node(sprite)
	if load_data() == 0:
		turn_off()
	else:
		turn_on()

func hit(_a, _b):
	print("Bonk")
	if state == OFF:
		turn_on()
	else:
		turn_off()

func load_data():
	var data = Data.load_temp(data_name)
	if data == null:
		data = 0
		Data.save_temp(data_name, 0)
	return data

func turn_on():
	if state == ON:
		return
	state = ON
	Data.save_temp(data_name, 1)
	sprite.set_modulate(Color(1.0, 1.0, 1.0, 1.0))

func turn_off():
	if state == OFF:
		return
	state = OFF
	Data.save_temp(data_name, 0)
	sprite.set_modulate(Color(0.5, 0.5, 0.5, 1.0))
