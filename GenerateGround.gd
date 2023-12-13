extends TileMap
class_name TileManager

const TILE_DIRT = Vector2i(0, 2)
const TILE_SKY = Vector2i(0, 4)
const TILE_STONE = Vector2i(10, 4)
const TILE_GOLD = Vector2i(5, 9)
const ATLAS_NO = 1

var layers_2_20 = [
	[0.9, TILE_STONE],
	[0.05, TILE_DIRT],
	[0.05, TILE_GOLD]
]
var layers_21 = [
	[0.8, TILE_STONE],
	[0.05, TILE_DIRT],
	[0.15, TILE_GOLD]
]

func get_random_tile(distribution):
	var randValue = randf()
	var cumProb = 0
	for item in distribution:
		var prob = item[0]
		var tile = item[1]
		cumProb += prob
		if randValue <= cumProb:
			return tile
	
	assert(false)

func _ready():
	for x in range(-10, 50):
		for y in range(100):
			var tile = TILE_STONE
			if y == 1:
				tile = TILE_STONE
			if y >= 2 and y <= 20:
				tile = get_random_tile(layers_2_20)
			if y >= 21:
				tile = get_random_tile(layers_21)
			set_cell(0, Vector2i(x, y), ATLAS_NO, tile)

func delete_tile(colliderId: RID):#globalCoord: Vector2):
	var coords = get_coords_for_body_rid(colliderId)
	set_cell(0, coords, ATLAS_NO, TILE_DIRT)

func get_tile_origin(colliderId: RID): 
	return to_global(map_to_local(get_coords_for_body_rid(colliderId)))

func get_tile_hardness(colliderId: RID) -> int:
	return get_coords_for_body_rid(colliderId)[1]

func get_tile_type(colliderId: RID):
	return get_cell_atlas_coords(0, get_coords_for_body_rid(colliderId))
	
func _process(delta):
	pass
