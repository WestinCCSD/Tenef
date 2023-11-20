class_name WallPair
extends Node


export(NodePath) var wall_base = null
export(NodePath) var wall_top = null
export(Vector2) var size = Vector2.ZERO
export(bool) var auto_pair = true



func _ready() -> void:
	if auto_pair:
		_pair()

func _pair() -> void:
	if wall_base == null or wall_top == null:
		print("Cannot pair walls if both wall base and top are null!")
		return
	if size.is_equal_approx(Vector2.ZERO):
		print("Cannot pair if the size of the grid is unknown!")
		return
	
	var base : TileMap = get_node(wall_base)
	var top : TileMap = get_node(wall_top)
	for y in range(size.y):
		for x in range(size.x):
			var index = base.get_cell(x, y)
			if index != -1:
				top.set_cell(x, y - 1, 0)
	
	base.update_bitmask_region()
	top.update_bitmask_region()
	
