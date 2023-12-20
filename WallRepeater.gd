extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var wallResource = load("res://Resources/wall.tscn")
	
	# LEFT
	for i in range(-10, 10):
		var wall = wallResource.instantiate()
		@warning_ignore("integer_division")
		wall.position.x = int(-(16 * 10 + 16/2))
		wall.position.y = int(i * wall.get_size().y)
		add_child(wall)
		
	# RIGHT
	for i in range(-10, 10):
		var wall = wallResource.instantiate()
		@warning_ignore("integer_division")
		wall.position.x = int(16 * 50 + 16/2)
		wall.position.y = int(i * wall.get_size().y)
		add_child(wall)
