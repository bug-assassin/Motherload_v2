extends TileMap


const TILE_SKY = Vector2i(0, 0)
const TILE_DIRT = Vector2i(0, 4)
const TILE_STONE = Vector2i(10, 4)
const ATLAS_NO = 1

func _ready():
	for x in range(20):
		for y in range(7):
			var tile = TILE_SKY if y < 2 else TILE_DIRT
			if y == 3:
				tile = TILE_STONE
			set_cell(0, Vector2i(x, y), ATLAS_NO, tile)
	print("finished")
	
func _process(delta):
	pass
