extends StaticBody2D


const Recipe = preload("res://src/Recipe.gd").Recipe
const use_distance : int = 100


var health : int = 6


var recipes = [
	Recipe.new("Iron Lump", 1, {
		"Iron Ore": 3,
	}),
	Recipe.new("Silver Lump", 1, {
		"Silver Ore": 3,
	}),
	Recipe.new("Iron Hatchet", 1, {
		"Iron Lump": 4,
		"Root": 6
	}),
	Recipe.new("Iron Pickaxe", 1, {
		"Iron Lump": 5,
		"Root": 5,
	}),
	Recipe.new("Iron Arming Sword", 1, {
		"Iron Lump": 6,
		"Root": 4
	}),
	Recipe.new("Iron Greatsword", 1, {
		"Iron Lump": 9,
		"Root": 3,
	}),
	Recipe.new("Iron Spear", 1, {
		"Iron Lump": 5,
		"Root": 7
	}),
	Recipe.new("Bascinet", 1, {
		"Iron Lump": 6,
		"Chain": 3
	})
]


func _on_interact():
	if position.distance_to(PlayerInventory.player.position) <= use_distance:
		PlayerInventory.player.get_node("InventoryUI")._set_recipes(recipes)
		PlayerInventory.player.get_node("InventoryUI")._toggle_inventory()


func _get_save_data() -> Game.Saveable:
	return Game.Saveable.new(
		"res://scenes/structures/Building_Smeltingkit.tscn",
		position,
		{}
	)


func _load_data(_data) -> void:
	pass


func _on_hit(_area):
	var item = PlayerInventory._get_selected_item()
	health -= item.hammer_power
	if health <= 0:
		_die()


func _die() -> void:
	var player = PlayerInventory.player
	if player != null:
		var iron = ItemLookup._get_as_item("Iron Ore")
		iron.amount = 2
		var stone = ItemLookup._get_as_item("Stone")
		stone.amount = 4
		player._spawn_dropped_item(iron, position)
		player._spawn_dropped_item(stone, position)
	queue_free()
