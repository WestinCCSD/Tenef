extends Node


const Saveable = preload("res://src/meta/Saveable.gd").Saveable



var fade_effect : CanvasLayer = null
var buffer_timer : Timer = null


var saves_path : String = "res://saves/"
var world_name : String = "world"

var queue_load : String = ""

var dungeon_pool : Array = [
	"res://scenes/dungeons/Subsurface.tscn",
]


var world_dict : Dictionary = {}


var cursor_icon = preload("res://assets/art/ui/pointer.png")


# custom data that gets saved
var world_flags = {}
var floor_number : int = 0


func _ready() -> void:
	buffer_timer = Timer.new()
	buffer_timer.autostart = false
	buffer_timer.one_shot = true
	buffer_timer.connect("timeout", self, "_buffer_timeout")
	call_deferred("add_child", buffer_timer)


func _unload_level() -> void:
	if get_tree().has_group("level"):
		get_tree().get_nodes_in_group("level")[0].queue_free()


func _load_level(p_level : String) -> void:
	queue_load = p_level
	var level_instance = load(p_level).instance()
	get_tree().get_root().add_child(level_instance)


func _change_level(p_level : String) -> void:
	_unload_level()
	yield(get_tree(), "idle_frame")
	_load_level(p_level)
	_update_singleton()


func _save_structures() -> void:
	var saveables : Array = []
	if get_tree().has_group("overworld"):
		saveables = get_tree().get_nodes_in_group("overworld")[0]._get_saveables()
		
		var filepath = Game.saves_path + Game.world_name + ".json"
		var data = SaveParser._open_file_dict(filepath)
		data.world.structures = saveables
		Game._save(data)
		


func _save_all() -> void:
	var save = SaveParser._open_file_dict(saves_path + world_name + ".json")
	
	if !save.has("player"):
		save["player"] = {
			"inventory_size": PlayerInventory.inventory_size,
			"inventory": [],
			"equipment": [],
			"quickq": PlayerInventory.quickq_index,
			"quicke": PlayerInventory.quicke_index
		}
	
	if !save.has("world_flags"):
		save["world_flags"] = {
			
		}
	
	save.world_flags.merge(world_flags, true)
	
	var inventory : Array = save.player.inventory
	inventory.clear()
	for item in PlayerInventory.storage:
		inventory.push_back([item.item_name, item.amount])
	
	save.player.inventory_size = PlayerInventory.inventory_size
	save.player.quickq = PlayerInventory.quickq_index
	save.player.quicke = PlayerInventory.quicke_index
	
#	for item in PlayerInventory.equipment:
#		save.player.equipment.push_back(item.item_name)
	
	if get_tree().has_group("overworld"):
		var overworld = get_tree().get_nodes_in_group("overworld")[0]
		var saveables : Array = overworld._get_saveables()
		save.world.structures.clear()
		save.world.structures = saveables
	
	
	_save(save)


func _update_singleton() -> void:
	AI._update()
	BuildingInfo._update()


func _create_dungeon() -> void:
	var rand_index : int = randi() % dungeon_pool.size()
	var next_level : String = dungeon_pool[rand_index]
	floor_number += 1
	call_deferred("_change_level", next_level)


func _set_player_position() -> void:
	if get_tree().has_group("player") and get_tree().has_group("player_spawn"):
		var player = get_tree().get_nodes_in_group("player")[0]
		var player_spawn = get_tree().get_nodes_in_group("player_spawn")[0]
		player.global_position = player_spawn.position
		


func _load() -> Dictionary:
	var file = File.new()
	file.open(saves_path + world_name + ".json", File.READ)
	var text = file.get_as_text()
	file.close()
	return SaveParser._to_dict(JSON.parse(text))


func _load_inventory(world_dat : Dictionary) -> void:
	if !world_dat.has("player"):
		Game._save_player_inventory() # saved to disk but the array is not changed
		
	var player_dat = world_dat.player
	PlayerInventory._resize_inventory(player_dat.inventory_size)
	
	var inventory = player_dat.inventory
	# item[0] item name
	# item[1] item amount
	for i in range(inventory.size()):
		var fetcheditem = ItemLookup._get_as_item(inventory[i][0])
		fetcheditem.amount = inventory[i][1]
		PlayerInventory.storage[i]._set_item(fetcheditem)
		if !PlayerInventory.storage_history.has(fetcheditem.item_name):
			PlayerInventory.storage_history[fetcheditem.item_name] = 0
		PlayerInventory.storage_history[fetcheditem.item_name] += fetcheditem.amount
	
	PlayerInventory.quickq_index = player_dat.quickq
	PlayerInventory.quicke_index = player_dat.quicke
	PlayerInventory.equipment.clear()
	
	
	
	world_flags = world_dat.world_flags


func _save(world_dict) -> void:
	world_dict = world_dict
	var file = File.new()
	file.open("res://saves/" + world_name + ".json", File.WRITE)
	var world_str = SaveParser._to_json(world_dict)
	file.store_string(world_str)
	file.close()
	
	#now we must check if this save is registered!
	#if not, register it now
	
	# does register exist?
	# create it if it does not
	if !file.file_exists("res://saves/data.json"):
		var base_dat = {
			"saves": []
		}
		file.open("res://saves/data.json", File.WRITE)
		var json = SaveParser._to_json(base_dat)
		file.store_string(json)
		file.close()
	
	file.open("res://saves/data.json", File.READ_WRITE)
	var dict = SaveParser._to_dict(file.get_as_text())
	if !dict.saves.has(world_name):
		dict.saves.push_back(world_name)
	file.store_string(SaveParser._to_json(dict))
	file.close()
	
	# :)


func _reset_pointer() -> void:
	Input.set_custom_mouse_cursor(cursor_icon)


func _save_player_inventory() -> void:
	#load in data
	var save = SaveParser._open_file_dict(saves_path + world_name + ".json")
	
	if !save.has("player"):
		save["player"] = {
			"inventory_size": PlayerInventory.inventory_size,
			"inventory": [],
			"quickq": -1,
			"quicke": -1
		}
	
	var inventory : Array = save.player.inventory
	inventory.clear()
	for item in PlayerInventory.storage:
		inventory.push_back([item.item_name, item.amount])
	
	save.player.inventory_size = PlayerInventory.inventory_size
	save.player.quickq = PlayerInventory.quickq_index
	save.player.quicke = PlayerInventory.quicke_index
	
	_save(save)


func _request_background_music(audio) -> void:
	if buffer_timer.is_stopped():
		audio.play()


func _start_background_music_buffer(audio) -> void:
	if buffer_timer != null:
		var length = rand_range((audio.minimum_buffer_time * 60), (audio.maximum_buffer_time * 60))
		buffer_timer.start(length)


func _buffer_timeout() -> void:
	get_tree().call_group("background_music", "play")
