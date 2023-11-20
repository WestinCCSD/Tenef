class_name InventoryUIInstance
extends Node


signal boxes_created


const itembox_scene = preload("res://scenes/ui/Itembox.tscn")


export(NodePath) var parent = null
export(bool) var bindable = true
var inventory : Inventory = null


# how many itemboxes go into a row
export(int) var rowx = 5
export(Vector2) var box_offset = Vector2.ZERO


func _create_item_boxes(remove_boxes : bool = true, custom_tex : Texture = null, bind : bool = false) -> void:
	if remove_boxes:
		get_tree().call_group("itemboxes", "queue_free")
	if inventory == null:
		inventory = PlayerInventory
	var rowy : int = 0
	for i in inventory.storage.size():
		var parent_ref = get_node(parent)
		#warning-ignore:narrowing_conversion
		rowy = floor(i / rowx)
		var instance = itembox_scene.instance()
		instance.rowx = rowx
		instance.custom_texture = custom_tex
		instance.offset = box_offset
		instance.position.x = (i * 100 + box_offset.x) - rowy * (rowx * 100) # strange looking code here, simply keeps box's x axis correct
		instance.position.y = rowy * 100 + box_offset.y
		instance.index = i
		if bind:
			if i == PlayerInventory.quickq_index:
				instance.call_deferred("add_to_group", "quickitemboxq")
				instance.call_deferred("_toggle_quick_q", false)
			if i == PlayerInventory.quicke_index:
				instance.call_deferred("add_to_group", "quickitemboxe")
				instance.call_deferred("_toggle_quick_e", false)
		instance.bindable = bindable
		instance.inventory = inventory
		instance.connect("itembox_clicked", parent_ref, "_on_itembox_clicked")
		instance.pickable = true
		parent_ref.add_child(instance)
	get_tree().call_group("itemboxes", "_update_self")
	emit_signal("boxes_created")


# changes the sprites and items stored in each inventory box
func _update_inventory() -> void:
	get_tree().call_group("itemboxes", "_update_self")
	get_tree().call_group("equipboxes", "_update_self")
	PlayerInventory.player._spawn_ghost_item(inventory.storage[PlayerInventory.selection_index])
