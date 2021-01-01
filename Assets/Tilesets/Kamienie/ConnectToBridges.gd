tool
extends TileSet

const GROUND = 0
const BRIDGE = 1

var binds = {
	GROUND : [BRIDGE],
	BRIDGE : [GROUND]
}

func _is_tile_bound(drawn_id, neighbor_id):
	if drawn_id in binds:
		return neighbor_id in binds[drawn_id]
	return false
