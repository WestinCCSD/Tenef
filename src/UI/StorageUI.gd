extends CanvasLayer


signal name_changed(new_name)
var holding_item : bool = false
var inventory : Inventory = null


func _on_name_changed(new_text):
	emit_signal("name_changed", new_text)


func _set_name(text) -> void:
	$UI/NameEdit.text = text


func _physics_process(_delta):
	if Input.is_action_just_pressed("close"):
		call_deferred("_close")


func _ready() -> void:
	$InventoryInstance._create_item_boxes()
	$StorageInstance.inventory = inventory
	$StorageInstance._create_item_boxes(false, load("res://assets/art/ui/item_box_storage.png"))


# code that's executed when any item box is clicked
func _on_itembox_clicked(index : int, box : Node, inventory : Inventory) -> void:
	if holding_item:
		# is the item we're clicking on the same as the one that's being held/following the cursor? if so, add item to the stack
		if inventory.storage[index].item_name == get_node("HeldItem").stored_item.item_name:
			var remainder = inventory.storage[index]._add_stack(get_node("HeldItem").stored_item.amount)
			# do we need to delete the held item or can we simply change amount?
			if  remainder > 0:
				get_node("HeldItem").stored_item.amount = remainder
			else:
				get_node("HeldItem").queue_free()
				holding_item = false
		# is the box we're trying to place the item in a blank space? if so, simply put item there
		elif inventory.storage[index].item_name == "blank_item":
			inventory.storage[index]._set_item(get_node("HeldItem").stored_item)
			box._create_info()
			
			get_node("HeldItem").queue_free()
			holding_item = false
		# is the item we're clicking NOT the same as the one that's being held? if so, swap item
		else:
			# an "offhand" item with which we can store the data of one item, overwrite that item, then replace the original we swapped it with
			var offhand : Item = Item.new()
			# set this offhand to value that's about to be replaced
			offhand._set_item(inventory.storage[index])
			# overwrite the box that's been clicked with item we're already holding
			inventory.storage[index]._set_item(get_node("HeldItem").stored_item)
			# swap currently held item with the item that was originally in the box
			get_node("HeldItem").stored_item._set_item(offhand)
			get_node("HeldItem")._update_cursor()
		
		
	else:
		if inventory.storage[index].item_name == "blank_item":
			return
		var scene : PackedScene = load("res://scenes/ui/HeldItem.tscn")
		var instance = scene.instance()
		var item : Item = inventory.storage[index]
		instance.stored_item = Item.new() #DING DING DING <- (Who's the idiot that wrote that? I think there was a bug here once...)
		instance.stored_item._set_item(item)
		instance._update_cursor()
		add_child(instance)
		holding_item = true
		inventory.storage[index]._clear_item()
	$InventoryInstance._update_inventory()


func _close() -> void:
	if get_tree().has_group("InventoryUI"):
		var inventoryui = get_tree().get_nodes_in_group("InventoryUI")[0]
		inventoryui._create_item_boxes()
	get_tree().call_group("itemboxes", "_delete_info")
	PlayerInventory._recalculate_history()
	call_deferred("queue_free")


func _set_inventory(pinventory : Inventory) -> void:
	$StorageInstance.inventory = pinventory
