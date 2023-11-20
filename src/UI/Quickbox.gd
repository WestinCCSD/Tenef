extends "res://src/Itembox.gd"


enum QuickType {
	Q,
	E
}


export(QuickType) var type


func _ready() -> void:
	._ready()
	if type == QuickType.Q:
		$BaseSprite.texture = load("res://assets/art/ui/quick_box_q.png")
	else:
		$BaseSprite.texture = load("res://assets/art/ui/quick_box_e.png")
	remove_from_group("itemboxes")


func _physics_process(_delta):
	hovered = false # quickboxes are already bound to quick use slots so they shouldn't be selected
	if type == QuickType.Q:
		_update("quickitemboxq")
	else:
		_update("quickitemboxe")


func _hide() -> void:
	hide()


func _show() -> void:
	if item == null:
		_hide()
	else:
		if item.item_name.hash() == "blank_item".hash():
			_hide()


func _update(group : String) -> void:
	var pairedboxes = get_tree().get_nodes_in_group(group)
	if pairedboxes.size() != 0:
		var pairedbox = pairedboxes[0]
		_set_item(pairedbox.item)
		_update_self()
	else:
		item = Item.new()
		_update_self()
