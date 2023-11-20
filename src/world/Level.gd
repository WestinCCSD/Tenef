class_name Level
extends YSort


# whether or not the player can build here
export(bool) var buildable = false


func _ready() -> void:
	var adze = ItemLookup._get_as_item("Stone Adze")
	adze.amount = 1
	var sword = ItemLookup._get_as_item("Iron Greatsword")
	sword.amount = 1
	var player = PlayerInventory.player
	player._spawn_dropped_item(adze, player.position)
	player._spawn_dropped_item(sword, player.position)


