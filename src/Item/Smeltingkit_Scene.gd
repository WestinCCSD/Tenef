extends Node2D


func _ready() -> void:
	var mouse_pos = get_global_mouse_position()
	var grid_pos = BuildingInfo._to_grid(mouse_pos)
	var ghost_building : Node = null
	if get_tree().has_group("ghost_building"):
		ghost_building = get_tree().get_nodes_in_group("ghost_building")[0]
	if ghost_building.space_available:
		var instance = load("res://scenes/structures/Building_Smeltingkit.tscn").instance()
		instance.position = grid_pos * BuildingInfo.cell_size
		get_parent().get_parent().call_deferred("add_child", instance) # player -> level.add_child
		get_tree().call_group("ghost_building", "queue_free")
		_remove_smeltingkit()
	queue_free()


func _remove_smeltingkit() -> void:
	var item = ItemLookup._get_as_item("Smelting Kit")
	item.amount = 1
	PlayerInventory.player._remove_item(item)
