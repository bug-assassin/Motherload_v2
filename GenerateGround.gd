extends TileMap
class_name TileManager

class Mineral:
	var type: MineralType
	var name: String
	var points : int
	var cost : int
	var weight : int
	var min_depth : int
	var common_depth : int
	var atlas_no: int
	var atlas_tile_no: Vector2i
	func _init(type: MineralType, name: String, cost: int, weight: int, min_depth: int, common_depth: int, atlas_no: int, atlas_tile_coord: Vector2i):
		self.type = type
		self.name = name
		self.cost = cost
		self.weight = weight
		self.min_depth = min_depth
		self.common_depth = common_depth
		self.atlas_no = atlas_no
		self.atlas_tile_no = atlas_tile_coord

enum MineralType {
	DIRT,
	IRONIUM,
	BRONZIUM,
	SILVERIUM,
	GOLDIUM,
	PLATINUM,
	EINSTEINIUM,
	EMERALD,
	RUBY,
	DIAMOND,
	AMAZONITE,
	ERROR
}

class Tuple:
	var first
	var second
	func _init(first, second):
		self.first = first
		self.second = second

const TILE_BACKGROUND_DIRT_ATLAS_NO = 1
const TILE_BACKGROUND_DIRT = Vector2i(0, 2)
const ATLAS_NO = 0
const TILE_HEIGHT_METERS = 4

const DIRT_INDEX = 0
var minerals: Array[Mineral] = [
	Mineral.new(MineralType.DIRT, "dirt", 0, 0, 0, 0, ATLAS_NO, Vector2i(1, 5)),
	Mineral.new(MineralType.IRONIUM, "ironium", 30, 10, 5, 5, ATLAS_NO, Vector2i(0, 2)),
	Mineral.new(MineralType.BRONZIUM, "bronzium", 60, 10, 5, 5, ATLAS_NO, Vector2i(0, 5)),
	Mineral.new(MineralType.SILVERIUM, "silverium", 100, 10, 5, 5, ATLAS_NO, Vector2i(0, 4)),
	Mineral.new(MineralType.GOLDIUM, "goldium", 250, 20, 5, 75, ATLAS_NO, Vector2i(0, 3)),
	Mineral.new(MineralType.PLATINUM, "platinum", 750, 30, 245, 1700, ATLAS_NO, Vector2i(6, 5)),
	Mineral.new(MineralType.EINSTEINIUM, "einsteinium", 2000, 40, 490, 790, ATLAS_NO, Vector2i(6, 4)),
	Mineral.new(MineralType.EMERALD, "emerald", 5000, 60, 730, 1220, ATLAS_NO, Vector2i(6, 3)),
	Mineral.new(MineralType.RUBY, "ruby", 20000, 80, 1220, 1460, ATLAS_NO, Vector2i(6, 2)),
	Mineral.new(MineralType.DIAMOND, "diamond", 100000, 100, 1340, 1735, ATLAS_NO, Vector2i(6, 1)),
	Mineral.new(MineralType.AMAZONITE, "amazonite", 500000, 120, 1675, 1890, ATLAS_NO, Vector2i(12, 3))
]

func get_random_mineral_from_distribution(distribution: Array[Tuple]) -> Mineral:
	var randValue = randf()
	var cumProb = 0
	distribution.sort_custom(func(itemA, itemB): return itemA.first > itemB.first)
	for item in distribution:
		var prob = item.first
		var mineral = item.second
		cumProb += prob
		if randValue <= cumProb:
			return mineral
	assert(false)
	return null

func generate_mineral_weighted_distribution(depth) -> Array[Tuple]:
	var candidates: Array[Mineral] = []
	for mineral in minerals:
		if mineral.type == MineralType.DIRT:
			continue
		if depth >= mineral.min_depth:
			candidates.append(mineral)
	
	assert(len(candidates) > 0)
	candidates = candidates.filter(func(candidate): return abs(depth - candidate.common_depth) < 500)
	assert(len(candidates) > 0)
	
	# exponential weighted rating by depth
	var ratings = candidates.map(func(candidate): return abs(depth - candidate.common_depth))
	var sum: float = ratings.reduce(func(accum, number): return accum+number)
	var weightedRatings = ratings.map(func(number): return number / sum)
	
	# around 3->15% of tiles are ores
	var percentOres = roundi(randf_range(3, 15)) / 100.0
	
	var final_distribution: Array[Tuple] = [
		Tuple.new(1-percentOres, minerals[DIRT_INDEX])
	]
	for i in range(len(weightedRatings)):
		var probability = weightedRatings[i] * percentOres
		var mineral = candidates[i]
		final_distribution.append(Tuple.new(probability, mineral))
	
	var final_distribution_total = final_distribution.map(func(item): return item.first).reduce(func(accum, item): return accum+item)
	assert(abs(final_distribution_total - 1) < 0.001) # total == 1 but since we're using floating points, we need to give a margin of error
	return final_distribution
			
func _ready():
	for x in range(-10, 50):
		for y in range(100):
			var mineral: Mineral = minerals[DIRT_INDEX]
			if y > 1:
				var depth = y * TILE_HEIGHT_METERS
				var minerals_distribution = generate_mineral_weighted_distribution(depth)
				mineral = get_random_mineral_from_distribution(minerals_distribution)
			set_cell(0, Vector2i(x, y), mineral.atlas_no, mineral.atlas_tile_no)
			
			if Constants.DEBUG:
				assert(get_cell_tile_data(0, Vector2i(x, y)).get_custom_data("name") == mineral.name)

func delete_tile(colliderId: RID):#globalCoord: Vector2):
	var coords = get_coords_for_body_rid(colliderId)
	set_cell(0, coords, TILE_BACKGROUND_DIRT_ATLAS_NO, TILE_BACKGROUND_DIRT)

func get_tile_origin(colliderId: RID): 
	return to_global(map_to_local(get_coords_for_body_rid(colliderId)))

func get_tile_hardness(colliderId: RID) -> int:
	return get_coords_for_body_rid(colliderId)[1]

func get_tile_mineral(colliderId: RID) -> Mineral:
	var name = get_cell_tile_data(0, get_coords_for_body_rid(colliderId)).get_custom_data("name")
	if Constants.DEBUG:
		print(name)
	for mineral in minerals:
		if mineral.name == name:
			return mineral
	return null

func _process(delta):
	pass
