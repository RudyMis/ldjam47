tool
extends TileSet

const GROUND = 0
const BACK = 4

var binds = {
	BACK : [GROUND]
}

func _is_tile_bound(drawn_id, neighbor_id):
	if drawn_id in binds:
		return neighbor_id in binds[drawn_id]
	print(drawn_id)
	return false
