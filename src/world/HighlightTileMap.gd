class_name HighlightTileMap
extends TileMap


export(NodePath) var highlight_box = null
export(NodePath) var pair = null
export(Vector2) var box_offset = Vector2.ZERO
export(bool) var can_destroy = false


func _physics_process(_delta):
	var box = get_node(highlight_box)
	if PlayerInventory._get_selected_item().pick_power >= 1:
		var highlighted_cell = world_to_map(get_global_mouse_position())
		var top = get_node(pair)
		if get_cellv(highlighted_cell) != -1:
			box.visible = true
			box.rect_position = (highlighted_cell * cell_size.x) + box_offset
		else:
			box.visible = false
	else:
		box.visible = false


func _destroy_tile(tile : Vector2) -> void:
	if get_cellv(tile) != -1:
		set_cellv(tile, -1)
		_spawn_loot(map_to_world(tile))


func _spawn_loot(pposition : Vector2) -> void:
	pass
