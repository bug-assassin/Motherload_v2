extends TileMap

func _ready():
	# Set the tileset for the TileMap (replace "your_tileset" with the actual path to your tileset).
	var tileset = preload("res://new_tile_set.tres")
	set_tileset(tileset)

	# Generate a 20x20 tilemap with random tiles.
	for x in range(20):
		for y in range(20):
			# Get a random tile index from the tileset.
			#var random_tile_index = randi() % tileset.get_tile_count()
			# Set the random tile at the current position.
			#self.set_cell(0, Vector2i(x, y), random_tile_index)
			pass

func process():
	pass
