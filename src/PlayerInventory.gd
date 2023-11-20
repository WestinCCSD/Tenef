extends Inventory


var equipment : Array = [
	Item.new(), # head
	Item.new(), # body
	Item.new(), # legs
	Item.new() # trinket
]


var quickq_index : int = -1
var quicke_index : int = -1
var selection_index : int = 0
var player : Node = null


var gold : int = 0


func _reset_size() -> void:
	_resize_inventory(15)


# mostly for use in loading save files
func _rebind() -> void:
	if get_tree().has_group("quickitemboxq"):
		if quickq_index != -1:
			var itemboxq = get_tree().get_nodes_in_group("quickitemboxq")[0]
			itemboxq.item = storage[quickq_index]
			itemboxq._update_self()
	if get_tree().has_group("quickitemboxe"):
		if quicke_index != 1:
			var itemboxe = get_tree().get_nodes_in_group("quickitemboxe")[0]
			itemboxe.item = storage[quicke_index]
			itemboxe._update_self()


func _ready() -> void:
	_reset_size()


func _get_selected_item() -> Item:
	var item = Item.new()
	item._set_item(storage[selection_index])
	return item


func _fetch_player() -> void:
	if get_tree().has_group("player"):
		player = get_tree().get_nodes_in_group("player")[0]


# deletes all item boxes and recreates them
func _reset_inventory_ui() -> void:
	if get_tree().has_group("InventoryUI"):
		var inventoryui = get_tree().get_nodes_in_group("InventoryUI")[0]
		inventoryui._create_item_boxes()


# simply refreshes item boxes
func _update_inventory_ui() -> void:
	if get_tree().has_group("InventoryUI"):
		var inventoryui = get_tree().get_nodes_in_group("InventoryUI")[0]
		inventoryui._update_inventory()


func _add_gold(amount : int) -> void:
	gold += amount
	player._update_gold()


func _remove_gold(amount : int) -> void:
	gold -= amount
	player._update_gold()


func _set_gold(amount : int) -> void:
	gold = amount


func _remove_cursed_items(penalize_mats : bool) -> void:
	for i in storage.size():
		if storage[i].cursed:
			storage[i]._clear_item()
		if storage[i].material and penalize_mats:
			storage[i].amount = ceil(storage[i].amount * 0.67)
	for i in equipment.size():
		if equipment[i].cursed:
			equipment[i]._clear_item()
	gold = 0
	player._update_gold()
	_recalculate_history()
	_update_inventory_ui()


func _print_defense() -> void:
	var sum : int = 0 
	for i in range(equipment.size()):
		sum += equipment[i].defense
	print(sum)
