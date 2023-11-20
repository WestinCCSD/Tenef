extends Node2D

signal itembox_clicked

var item : Item = null
# the position in the players inventory this item is meant to correspond to
var index : int = 0

var rowx : int = 5
var offset : Vector2 = Vector2.ZERO

# if this item can be picked up or not
var pickable : bool = false
var hovered : bool = false
# if this item can be bound to quick slots
var bindable : bool = false


var child_info : Node = null
var inventory : Inventory = null
export(Texture) var custom_texture = null


func _ready():
	_set_item(ItemLookup._get_as_item("blank_item"))
	#$Anims.play("box_zoom", -1, -1.0, true)
	if custom_texture != null:
		$BaseSprite.texture = custom_texture


func _physics_process(_delta):
	if hovered and bindable:
		if Input.is_action_just_pressed("binde"):
			var toggle = is_in_group("quickitemboxe")
			get_tree().call_group("quickitemboxe", "_reset_e")
			PlayerInventory.quicke_index = index
			_toggle_quick_e(toggle)
		if Input.is_action_just_pressed("bindq"):
			var toggle = is_in_group("quickitemboxq")
			get_tree().call_group("quickitemboxq", "_reset_q")
			PlayerInventory.quickq_index = index
			_toggle_quick_q(toggle)



func _update_self() -> void:
	if inventory != null:
		_set_item(inventory.storage[index])
	if item.item_name.hash() == "blank_item".hash():
		$Amount.hide()
	else:
		$Amount.show()
	$Amount.text = str(item.amount)
	_update_sprites()


func _set_item(p_item : Item) -> void:
	item = p_item
	_update_sprites()


func _hide_box() -> void:
	if index < rowx:
		# if this item is in tool bar, don't hide, just move
		$BaseSprite.scale = Vector2(1, 1)
		$Amount.rect_position = Vector2(0, 16)
		$ItemButton.rect_size = Vector2(96, 96)
		$ItemButton.rect_position = Vector2(-48, -48)
		pickable = false
		position.x -= 64
		position.y -= 64
	else:
		hide()
	hovered = false

func _show_box() -> void:
	pickable = true
	if index < rowx:
			position.x += 64
			position.y += 64
	show()

func _update_sprites() -> void:
	if item != null:
		$BaseSprite/Weapon.texture = item.item_texture

func _on_item_button_pressed():
	if pickable:
		emit_signal("itembox_clicked", index, self, inventory)
		_delete_info()


func _on_mouse_entered():
	hovered = true
	if pickable:
		$Anims.play("box_zoom")
		if item.item_name != "blank_item":
			_create_info()


func _on_mouse_exited():
	hovered = false
	if pickable:
		$Anims.play("box_zoom", -1, -1.0, true)
	_delete_info()


func _update_selection() -> void:
	if inventory != PlayerInventory:
		return
	if index == inventory.selection_index:
		$Selection.show()
	else:
		$Selection.hide()

func _create_info() -> void:
	var instance = load("res://scenes/ui/ItemInfo.tscn").instance()
	instance._update_info(item)
	get_parent().add_child(instance)
	child_info = instance


func _delete_info() -> void:
	if child_info != null:
		child_info._delete()
		child_info = null


func _reset_size() -> void:
	$Anims.stop()


func _toggle_quick_q(toggle : bool = false) -> void:
	if pickable:
		if toggle:
			remove_from_group("quickitemboxq")
			PlayerInventory.quickq_index = -1
			$BaseSprite/IconQ.hide()
		else:
			add_to_group("quickitemboxq")
			PlayerInventory.quickq_index = index
			$BaseSprite/IconQ.show()


func _toggle_quick_e(toggle : bool = false) -> void:
	if pickable:
		if toggle:
			remove_from_group("quickitemboxe")
			PlayerInventory.quicke_index = -1
			$BaseSprite/IconE.hide()
		else:
			add_to_group("quickitemboxe")
			PlayerInventory.quicke_index = index
			$BaseSprite/IconE.show()


func _quick_reset() -> void:
	_reset_e()
	_reset_q()


func _reset_e() -> void:
	if get_tree().has_group("quickitemboxe"):
		remove_from_group("quickitemboxe")
	$BaseSprite/IconE.hide()


func _reset_q() -> void:
	if get_tree().has_group("quickitemboxq"):
		remove_from_group("quickitemboxq")
	$BaseSprite/IconQ.hide()
