extends StaticBody2D


export(int) var health = 4


var Recipe = load("res://src/Recipe.gd").Recipe
var Saveable = Game.Saveable


var recipes = [
	Recipe.new("Wood Hat", 1, {
		"Wood": 3,
		"Lumber": 1,
	}),
	Recipe.new("Wood Cuirass", 1, {
		"Wood": 6,
		"Lumber": 2,
	}),
	Recipe.new("Sandals", 1, {
		"Wood": 2,
		"Lumber": 1,
	}),
	Recipe.new("Polished Adze", 1, {
		"Stone Adze": 1,
		"Wood": 3,
	}),
	Recipe.new("Polished Pick", 1, {
		"Stone Pick": 1,
		"Stone": 3,
	}),
	Recipe.new("Stone Hammer", 1, {
		"Wood": 4,
		"Stone": 3
	}),
	Recipe.new("Wooden Shield", 1, {
		"Wood": 4,
		"Lumber": 2
	}),
	Recipe.new("Bone Sword", 1, {
		"Bone Scraps": 4,
		"Lumber": 1,
	}),
	Recipe.new("Bone Pick", 1, {
		"Bone Scraps": 5,
		"Lumber": 2,
	}),
	Recipe.new("Smelting Kit", 1, {
		"Stone": 15,
		"Lumber": 1,
		"Iron Ore": 3,
	}),
	Recipe.new("Storage Chest", 1, {
		"Lumber": 3,
		"Wood": 5
	})
]


# how many pixels away the player can be before the bench is no longer reachable
var use_distance : int = 100

# player has attempted to open the workbench
func _on_pressed():
	if position.distance_to(PlayerInventory.player.position) <= use_distance:
		PlayerInventory.player.get_node("InventoryUI")._set_recipes(recipes)
		PlayerInventory.player.get_node("InventoryUI")._toggle_inventory()


func _get_save_data() -> Game.Saveable:
	var savedata = Saveable.new("res://scenes/structures/Building_Workbench.tscn", position, {})
	return savedata


func _load_data(_prevdata : Dictionary) -> void:
	pass


func _on_hit(_area) -> void:
	var item = PlayerInventory._get_selected_item()
	if item.hammer_power >= 1:
		_damage(item.hammer_power)


func _damage(amount : int) -> void:
	health -= amount
	if health <= 0:
		_die()


func _die() -> void:
	var player = PlayerInventory.player
	if player != null:
		var item = ItemLookup._get_as_item("Lumber")
		item.amount = 1
		player._spawn_dropped_item(item, position)
		queue_free()
