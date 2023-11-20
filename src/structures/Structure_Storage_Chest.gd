extends StaticBody2D


var display_name : String = ""


var UI : PackedScene = preload("res://scenes/ui/StorageUI.tscn")


export(float) var use_distance = 100.0
export(int) var default_size = 20
var player : Node2D = null


var open : bool = false


func _ready() -> void:
	if get_tree().has_group("player"):
		player = get_tree().get_nodes_in_group("player")[0]
	$Inventory._resize_inventory(default_size)


func _physics_process(_delta):
	if open and (position.distance_to(player.position) > use_distance):
		_close()


func _on_use() -> void:
	if !open and (position.distance_to(player.position) <= use_distance):
		_open()
	elif open:
		_close()


func _open() -> void:
	open = true
	$Chest.play("open")
	var instance = UI.instance()
	instance.connect("name_changed", self, "_on_name_changed")
	instance.connect("tree_exited", self, "_close")
	instance.inventory = $Inventory
	add_child(instance)
	instance._set_name(display_name)
	
	if PlayerInventory.player != null:
		PlayerInventory.player.typing_mode = true


func _close() -> void:
	open = false
	$Chest.play("default")
	if get_tree() != null: # can cause problems if the game is force closed
		get_tree().call_group("storageui", "queue_free")
	if PlayerInventory.player != null:
		PlayerInventory.player.typing_mode = false


func _on_name_changed(new_name) -> void:
	display_name = new_name


func _on_touch() -> void:
	if display_name.hash() != "".hash():
		var instance = load("res://scenes/ui/DisplayName.tscn").instance()
		get_parent().add_child(instance)
		instance._set_name(display_name)


func _on_untouch() -> void:
	if get_tree().has_group("displayname"):
		get_tree().call_group("displayname", "queue_free")


func _get_save_data() -> Game.Saveable:
	return Game.Saveable.new("res://scenes/structures/Structure_Storage_Chest.tscn", position, {
		"name": display_name,
		"storage": $Inventory._to_arr()
		})


func _load_data(data : Dictionary) -> void:
	display_name = data.name
	$Inventory._from_arr(data.storage)

