extends TileMapLayer

func _ready() -> void:
	var filled_tiles := get_used_cells()
	for filled_tile: Vector2i in filled_tiles:
		var tiles_vecinos := get_surrounding_cells(filled_tile)
		for vecino: Vector2i in tiles_vecinos:
			if get_cell_source_id(vecino) == -1:
				set_cell(vecino, 0, Vector2i.ZERO)
