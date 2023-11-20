extends Node2D


func _ready() -> void:
	if get_tree().has_group("tilemap_roots"):
		var tilemap_roots : TileMap = get_tree().get_nodes_in_group("tilemap_roots")[0]
		var tile_cord = tilemap_roots.world_to_map(position)
		#if _can_place_roots(tile_cord):
		tilemap_roots.set_cell(tile_cord.x, tile_cord.y, 0)
		tilemap_roots.update_bitmask_area(tile_cord)
		AI.call_deferred("_set_navigation_tile", tile_cord.x, tile_cord.y, -1)
	else:
		print("Cannot find tilemap_roots!")
	queue_free()


func _can_place_roots(cords : Vector2) -> bool:
	if get_tree().has_group("tilemap_impassable"):
		var impassable = get_tree().get_nodes_in_group("tilemap_impassable")[0]
		var adjacent : PoolVector2Array = [
			Vector2(cords.x - 1, cords.y - 1), Vector2(cords.x, cords.y - 1), Vector2(cords.x + 1, cords.y - 1), # top row
			Vector2(cords.x - 1, cords.y),     Vector2(cords.x, cords.y),     Vector2(cords.x + 1, cords.y), # center row
			Vector2(cords.x - 1, cords.y + 1), Vector2(cords.x, cords.y + 1), Vector2(cords.x + 1, cords.y + 1) # bottom row
		]
		
		var adjacent_tolerance : int = 3
		var adjacent_count : int = 0
		
		for tile in adjacent:
			adjacent_count += _is_tile_available(impassable, tile)
		
		return adjacent_count < adjacent_tolerance
	else:
		return false


func _is_tile_available(tilemap : TileMap, tile : Vector2) -> int:
	if tilemap.get_cell(tile.x, tile.y) != -1:
		return 1
	else:
		return 0
