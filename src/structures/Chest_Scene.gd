extends Node2D


func _ready() -> void:
	if get_tree().has_group("tilemap_topmost"):
		var tilemap = get_tree().get_nodes_in_group("tilemap_topmost")[0]
	else:
		queue_free()
		return
	
	position
	


func _remove_chest() -> void:
	var item = ItemLookup._get_as_item("Storage Chest")
	item.amount = 1
	PlayerInventory.player._remove_item(item)
