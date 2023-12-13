extends Node2D

func get_size() -> Vector2:
	var sprite = get_node("Sprite2D")
	return Vector2(sprite.texture.get_width(), sprite.texture.get_height())
