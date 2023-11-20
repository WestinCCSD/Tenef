extends CanvasLayer


var hovered : bool = false


class Command:
	var input : String = ""
	
	func _call(_data : String, _console : Node) -> void:
		pass

class CommandGive extends Command:
	func _init() -> void:
		input = "give"
	
	
	func _call(data : String, console : Node) -> void:
		var splitdata = data.split(" ")
		
		if splitdata.size() != 3:
			console._add_to_history("Incorrect number of arguments!")
			return
		
		var itemname = splitdata[1]
		itemname = itemname.replace("_", " ")
		
		var item = Item.new()
		item = ItemLookup._get_as_item(itemname)
		item.amount = splitdata[2].to_int()
		
		var player = PlayerInventory.player
		if player == null:
			console._add_to_history("Player not found!")
			return
		else:
			player._give_item(item)
		
		console._add_to_history("Gave player " + splitdata[2] + "x " + itemname)

class CommandGold extends Command:
	func _init() -> void:
		input = "gold"
	
	func _call(data : String, console : Node) -> void:
		var parseddata = data.split(" ")
		
		if parseddata.size() != 2:
			console._add_to_history("Incorrect number of arguments!")
			return
		
		var amount = parseddata[1].to_int()
		
		PlayerInventory.gold += amount
		PlayerInventory.player._update_gold()
		console._add_to_history("Added " + parseddata[1] + " gold to player")
		

class CommandSuicide extends Command:
	func _init() -> void:
		input = "kill"
	
	func _call(_data : String, console : Node) -> void:
		var player = PlayerInventory.player
		if player != null:
			player._die()
			console._add_to_history("Player killed!")
		else:
			console._add_to_history("Player not found!")

class CommandSetHealth extends Command:
	func _init() -> void:
		input = "set health"
	
	func _call(data : String, console : Node) -> void:
		var parseddata = data.split(" ")
		
		if parseddata.size() != 3:
			console._add_to_history("Incorrect number of arguments!")
			return
		
		var player = PlayerInventory.player
		if player == null:
			console._add_to_history("Player not found!")
			return
		
		else:
			player.hp = parseddata[2].to_int()
			player.get_node("PlayerHud/Healthbar").value = player.hp
			console._add_to_history("Set player's health to " + parseddata[2])

class CommandClear extends Command:
	func _init() -> void:
		input = "clear"
	
	func _call(_data : String, console : Node) -> void:
		console._clear_history()

class CommandMOTD extends Command:
	func _init() -> void:
		input = "motd"
	
	func _call(_data, console : Node) -> void:
		console._add_to_history("Hello, welcome to the Tenef Island console!\nThis game was created mostly by Spixbox,\nthanks for playing! <3")

class CommandHelp extends Command:
	func _init() -> void:
		input = "help"
	
	func _call(_data, console : Node) -> void:
		console._help()

class CommandLevel extends Command:
	func _init() -> void:
		input = "load"
	
	func _call(data : String, console : Node) -> void:
		var parseddata : PoolStringArray = data.split(" ")
		
		var id = parseddata[1].to_int()
		
		if parseddata.size() != 2:
			console._add_to_history("Incorrect number of arguments!")
			return
		
		if id > (Game.dungeon_pool.size() - 1):
			console._add_to_history("No such level exists!")
			return
		
		console._add_to_history("Changed level to level at id " + parseddata[1])
		Game.call_deferred("_change_level", Game.dungeon_pool[id])

class CommandHome extends Command:
	func _init() -> void:
		input = "home"
	
	func _call(_data : String, console : Node) -> void:
		console._add_to_history("Going home!")
		Game.call_deferred("_change_level", "res://scenes/Overworld.tscn")

class CommandKillAll extends Command:
	func _init() -> void:
		input = "kill all"
	
	
	func _call(_data, console : Node) -> void:
		var enemy_count = console.get_tree().get_nodes_in_group("enemy").size()
		console.get_tree().call_group("enemy", "_die")
		console._add_to_history("Killed " + str(enemy_count) + " enemies!")

var commands : Array = [
	CommandHelp.new(),
	CommandGive.new(),
	CommandGold.new(),
	CommandKillAll.new(),
	CommandSuicide.new(),
	CommandSetHealth.new(),
	CommandClear.new(),
	CommandMOTD.new(),
	CommandLevel.new(),
	CommandHome.new()
]


func _physics_process(_delta) -> void:
	if Input.is_action_just_pressed("open_console"):
		visible = !visible
	if visible:
		if Input.is_action_just_pressed("ui_accept"):
			_call_command()
	
	if Input.is_action_pressed("use_item"):
		if hovered:
			$Base.rect_position = get_viewport().get_mouse_position()
			if $Base.rect_position.x >= 1920:
				$Base.rect_position.x = 1900
			if $Base.rect_position.y <= 0:
				$Base.rect_position.y = 10


func _handle_typing_mode() -> void:
	if PlayerInventory.player != null:
		PlayerInventory.player.typing_mode = visible


func _call_command() -> void:
	var input = $Base/Input.text
	$Base/Input.set_text("")
	
	for command in commands:
		if input.begins_with(command.input):
			command._call(input, self)
			return
	
	_add_to_history("Command not found!")


func _add_to_history(entry : String) -> void:
	var old_text : String = $Base/ScrollContainer/History.text
	old_text += entry
	old_text += "\n"
	$Base/ScrollContainer/History.set_text(old_text)
	$Base/ScrollContainer/History.set_deferred("scroll_vertical", 9999)


func _help() -> void:
	for command in commands:
		_add_to_history(command.input)


func _clear_history() -> void:
	$Base/ScrollContainer/History.set_text("")

# prevent user from accidentally inputting a tilde
func _on_text_change(new_text) -> void:
	if new_text.ends_with("`"):
		new_text.erase(new_text.length() - 1, 1)
		$Base/Input.text = new_text


func _on_mouse_grabber_hover() -> void:
	hovered = true


func _on_mouse_grabber_unhover():
	hovered = false

