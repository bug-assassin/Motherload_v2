extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var wallResource = load("res://Resources/wall.tscn")
	
	# LEFT
	for i in range(-10, 10):
		var wall = wallResource.instantiate()
		wall.position.x = -(16 * 10 + 16/2)
		wall.position.y = i * wall.get_size().y
		add_child(wall)
		
	# RIGHT
	for i in range(-10, 10):
		var wall = wallResource.instantiate()
		wall.position.x = (16 * 50 + 16/2)
		wall.position.y = i * wall.get_size().y
		add_child(wall)
