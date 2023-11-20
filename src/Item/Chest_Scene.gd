extends Node2D


const boxscene = preload("res://scenes/structures/Structure_Storage_Chest.tscn")
export(Vector2) var box_offset = Vector2.ZERO



func _ready() -> void:
	var ghost_building : Node2D = null
	if get_tree().has_group("ghost_building"):
		ghost_building = get_tree().get_nodes_in_group("ghost_building")[0]
	else:
		queue_free()
		return
	
	if ghost_building.space_available:
		var boxinstance = boxscene.instance()
		boxinstance.position = BuildingInfo._to_grid(get_global_mouse_position()) * BuildingInfo.cell_size
		boxinstance.position += box_offset
		get_tree().call_group("ghost_building", "queue_free")
		get_parent().get_parent().add_child(boxinstance)
		_remove_item()
		queue_free()


func _remove_item() -> void:
	var item = ItemLookup._get_as_item("Storage Chest")
	item.amount = 1
	PlayerInventory.player._remove_item(item)
