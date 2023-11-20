extends Node

const folder_weapon_texture = "res://assets/art/weapons/"
const folder_weapon_scene = "res://scenes/weapons/"

const folder_item_texture = "res://assets/art/items/"

const default_scene = "res://scenes/weapons/item_default_scene.tscn"


var Recipe = load("res://src/Recipe.gd").Recipe


# grey
const quality_junk = Color(0.6, 0.6, 0.6)
# white
const quality_common = Color(1.0, 1.0, 1.0)
# skyish blue
const quality_uncommon = Color(0.2, 0.65, 0.8)
# nice violet
const quality_rare = Color(0.70, 0.1, 0.75)
# orange
const quality_legendary = Color(0.9, 0.47, 0.094)
# red
const quality_cursed = Color(0.8, 0.1, 0.1)


func _ready():
	randomize()


# a dictionary holding data on every item in the game
# item registries go as follows "item_name": { "max_count": x, "texture": <path_to_texture>, [...] }
var registry = {
	
	"blank_item": {
		"max_count": 1,
		"texture": folder_item_texture + "item_blank.png",
		"on_use": default_scene,
		"description": "debug_item\nblank_description",
		"quality": quality_junk,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
		},
	"Wood": {
		"max_count": 99,
		"texture": folder_item_texture + "wood.png",
		"on_use": default_scene,
		"description": "Material",
		"quality": quality_junk,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
		"material": true,
	},
	"Stone": {
		"max_count": 99,
		"texture": folder_item_texture + "stone.png",
		"on_use": default_scene,
		"description": "Material",
		"quality": quality_junk,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
		"material": true,
	},
	"Lumber": {
		"max_count": 99,
		"texture": folder_item_texture + "lumber.png",
		"on_use": default_scene,
		"description": "Material\nLonger, more refined pieces of wood",
		"quality": quality_common,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
		"material": true,
	},
	"Iron Ore": {
		"max_count": 99,
		"texture": folder_item_texture + "iron_ore.png",
		"on_use": default_scene,
		"description": "Material\nCan be processed into iron using a smelting kit",
		"quality": quality_common,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
		"material": true,
	},
	"Iron Lump": {
		"max_count": 99,
		"texture": folder_item_texture + "iron_lump.png",
		"on_use": default_scene,
		"description": "Material\nCan be refined into tools and weaponry",
		"quality": quality_uncommon,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
		"material": true,
	},
	"Sand Sword": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_sand_sword.png",
		"on_use": folder_weapon_scene + "weapon_sand_sword.tscn",
		"description": "8 Damage\nModerate Speed\n3 Stamina\n\nFires balls of sand which deal minor damage and slows targets",
		"quality": quality_cursed,
		"ghost_texture": null,
		"cursed": true,
		"armor": 0,
		"defense": 0,
	},
	"Stone Spear": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_stone_spear.png",
		"on_use": folder_weapon_scene + "weapon_stone_spear.tscn",
		"description": "4 Damage\nModerate Speed\n2 Stamina",
		"quality": quality_junk,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
	},
	"Stone Adze": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_stone_adze.png",
		"on_use": folder_weapon_scene + "weapon_stone_adze.tscn",
		"description": "2 Damage\n2 Stamina\nSlow Speed\n\nCan harvest lumber",
		"quality": quality_junk,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
		"axe_power": 1,
		"stamina_cost": 3.0,
	},
	"Stone Pick": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_stone_pick.png",
		"on_use": folder_weapon_scene + "weapon_stone_pick.tscn",
		"description": "3 Damage\n4 Stamina\nSlow Speed\n\nCan harvest stone",
		"quality": quality_junk,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
		"pick_power": 1,
		"stamina_cost": 4.0,
	},
	"Primitive Club" : {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_club.png",
		"on_use": folder_weapon_scene + "weapon_club.tscn",
		"description": "4-6 Damage\n6 Stamina\nSlow Speed",
		"quality": quality_junk,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
		"stamina_cost": 6.0,
	},
	"Polished Adze": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_polish_adze.png",
		"on_use": folder_weapon_scene + "weapon_polished_adze.tscn",
		"description": "3-4 Damage\n3 Stamina\nModerate Speed\nCan harvest roots",
		"quality": quality_common,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
		"axe_power": 2,
		"stamina_cost": 3.0
	},
	"Polished Pick": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_polished_pick.png",
		"on_use": folder_weapon_scene + "weapon_polished_pick.tscn",
		"quality": quality_common,
		"description": "3-4 Damage\n3 Stamina\nSlow Speed\nCan harvest stone and terrametals",
		"pick_power" : 2,
		"stamina_cost": 3.0
	},
	"Stone Hammer": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_stone_hammer.png",
		"on_use": folder_weapon_scene + "weapon_stone_hammer.tscn",
		"quality": quality_common,
		"description": "3-4 Damage\n5 Stamina\nSlow Speed\nCan destroy placed buildings",
		"hammer_power": 1
	},
	"Workbench": {
		"max_count": 99,
		"texture": "res://assets/art/structures/building_workbench.png",
		"on_use": "res://scenes/items/Workbench_Scene.tscn",
		"description" : "Unlocks new recipes",
		"quality": quality_common,
		"ghost_texture": "res://assets/art/structures/building_workbench.png",
		"cursed": false,
		"armor": 0,
		"defense": 0,
	},
	"Storage Chest": {
		"max_count": 99,
		"texture": "res://assets/art/items/storage_chest.png",
		"description": "Holds 20 items",
		"quality": quality_common,
		"ghost_texture": "res://assets/art/structures/building_chest.png",
		"on_use": "res://scenes/items/Chest_Scene.tscn"
	},
	"Smelting Kit": {
		"max_count": 99,
		"texture": folder_item_texture + "smeltingkit.png",
		"on_use": "res://scenes/items/Smeltingkit_Scene.tscn",
		"description": "For all your smithing needs!",
		"quality": quality_common,
		"ghost_texture": "res://assets/art/structures/Building_Smeltingkit.png",
		"cursed": false,
		"armor": 0,
		"defense": 0,
	},
	"Backpack Cookie": {
		"max_count": 99,
		"texture": "res://assets/art/items/cookie.png",
		"on_use": "res://scenes/items/Cookie.tscn",
		"description": "Increases your backpack size\nChocolate chips, yum!",
		"quality": quality_legendary,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
	},
	"Silver Ore": {
		"max_count": 99,
		"texture": folder_item_texture + "silver_ore.png",
		"on_use": default_scene,
		"description": "Material\nCan be processed into silver using a smelting kit",
		"quality": quality_common,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
		"material": true,
	},
	"Silver Lump": {
		"max_count": 99,
		"texture": folder_item_texture + "silver_lump.png",
		"on_use": default_scene,
		"description": "Material\nCan be refined into tools and weaponry",
		"quality": quality_uncommon,
		"ghost_texture": null,
		"cursed": false,
		"armor": 0,
		"defense": 0,
		"material": true,
	},
	"Clay": {
		"max_count": 99,
		"texture": folder_item_texture + "clay.png",
		"description": "Material",
		"material": true,
		"quality": quality_common
	},
	"Small Health Potion": {
		"max_count": 99,
		"texture": folder_item_texture + "health_pot.png",
		"on_use": "res://scenes/items/PotionUse.tscn",
		"description": "Restores 20 HP\nShort consume time",
		"quality": quality_cursed,
		"ghost_texture": null,
		"cursed": true,
		"armor": 0,
		"defense": 0,
		"active_use": true,
	},
	"Wood Hat": {
		"max_count": 1,
		"texture": folder_item_texture + "wood_hat.png",
		"on_use": default_scene,
		"description": "2 Defense",
		"quality": quality_common,
		"ghost_texture": null,
		"cursed": false,
		"armor": 1,
		"defense": 2,
	},
	"Wood Cuirass": {
		"max_count": 1,
		"texture": folder_item_texture + "wood_chest.png",
		"on_use": default_scene,
		"description": "3 Defense",
		"quality": quality_common,
		"ghost_texture": null,
		"cursed": false,
		"armor": 2,
		"defense": 3,
	},
	"Sandals": {
		"max_count": 1,
		"texture": folder_item_texture + "wood_shoes.png",
		"on_use": default_scene,
		"description": "1 Defense",
		"quality": quality_common,
		"ghost_texture": null,
		"cursed": false,
		"armor": 3,
		"defense": 1,
	},
	"Root": {
		"max_count": 99,
		"texture": folder_item_texture + "root.png",
		"description": "Material\nTough as oak!",
		"quality": quality_common,
		"material": true
	},
	"Wooden Shield": {
		"max_count": 1,
		"texture": folder_weapon_texture + "wooden_shield.png",
		"on_use": folder_weapon_scene + "weapon_wooden_shield.tscn",
		"description": "35% Blocking Power\nHold to block, release to parry!",
		"quality": quality_common,
		"active_use": true
	},
	"Bone Scraps": {
		"max_count": 99,
		"texture" : folder_item_texture + "bonescraps.png",
		"description": "Material",
		"quality": quality_junk,
		"material": true,
	},
	"Bone Sword": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_bone_sword.png",
		"description": "5-6 Damage\n3 Stamina\nModerate Speed",
		"quality": quality_common,
		"on_use": folder_weapon_scene + "weapon_bone_sword.tscn"
	},
	"Bone Pick": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_bone_pick.png",
		"description": "4 Damage\n4 Stamina\nSlow speed\nCan harvest stone and terrametals",
		"quality": quality_common,
		"pick_power": 2,
	},
	# todo: bone axe
	"Iron Hatchet": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_iron_hatchet.png",
		"description": "4-5 Damage\n3 Stamina\nModerate Speed\nCan harvest root pillars",
		"quality": quality_uncommon,
		"axe_power": 3
	},
	"Iron Pickaxe": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_iron_pickaxe.png",
		"description": "5 Damage\n4 Stamina\nModerate Speed\nCan harvest terrametals and clay",
		"quality": quality_uncommon,
		"pick_power": 3
	},
	"Iron Greatsword": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_iron_greatsword.png",
		"description": "9-12 Damage\n8 Stamina\nSlow Speed\nStruck enemies may be stunned",
		"quality": quality_uncommon,
		"on_use": folder_weapon_scene + "weapon_iron_greatsword.tscn",
		"active_use": true,
		"stamina_cost": 7 # set to 7 so as to avoid strange bugs
	},
	"Iron Arming Sword": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_iron_sword.png",
		"description": "6-8 Damage\n5 Stamina\nModerate Speed\nStruck enemies may bleed",
		"quality": quality_uncommon
	},
	"Iron Spear": {
		"max_count": 1,
		"texture": folder_weapon_texture + "weapon_iron_spear.png",
		"description": "4-6 Damage\n4 Stamina\nModerate Speed",
		"quality": quality_uncommon
	},
	"Bascinet": {
		"max_count": 1,
		"texture": folder_item_texture + "bascinet.png",
		"description": "3 Armor",
		"quality": quality_uncommon
	},
	"Chain": {
		"max_count": 99,
		"texture": folder_item_texture + "chain.png",
		"description": "Material",
		"quality": quality_uncommon
	},
	"Happy Thoughts Pin": {
		"max_count": 1,
		"texture": folder_item_texture + "happythoughtspin.png",
		"description": "+5% and +15 max HP",
		"quality": quality_cursed,
		"ghost_texture": null,
		"cursed": true,
		"armor": 4
	},
	"Sweatband": {
		"max_count": 1,
		"texture": folder_item_texture + "sweatband.png",
		"description": "+15% stamina regeneration",
		"quality": quality_cursed,
		"cursed": true,
		"armor": 4
	},
	"Rubber Ducky": {
		"max_count": 1,
		"texture": folder_item_texture + "rubber_duck.png",
		"description": "Improves mobility while wet",
		"quality": quality_cursed,
		"cursed": true,
		"armor": 4
	},
	"Pauldron": {
		"max_count": 1,
		"texture": folder_item_texture + "pauldron.png",
		"description": "+5 max HP",
		"quality": quality_common,
		"armor": 4
	},
	"Honey Comb": {
		"max_count": 1,
		"texture": folder_item_texture + "honey_comb.png",
		"description": "Grants a small HOT effect after slaying an enemy",
		"quality": quality_cursed,
		"cursed": true,
		"armor": 4
	}
}

var recipe_registry = [
	Recipe.new("Stone Adze", 1, {
		"Wood": 2,
		"Stone": 4
	}),
	Recipe.new("Stone Pick", 1, {
		"Wood": 5,
		"Stone": 2,
	}),
	Recipe.new("Stone Spear", 1, {
		"Wood": 3,
		"Stone": 2,
	}),
	Recipe.new("Primitive Club", 1, {
		"Wood": 4
	}),
	Recipe.new("Workbench", 1, {
		"Wood": 3,
		"Lumber": 1
	}),
	Recipe.new("Backpack Cookie", 1, {
		"Wood": 1,
	}),
	
]

# converts a registry to a usable item. Count will remain -1
func _get_as_item(item_name : String) -> Item:
	var item = registry.get(item_name)
	if item == null:
		return Item.new()
	else:
		
		var maxcount = 99
		var texture = folder_item_texture + "item_blank.png"
		var onuse = default_scene
		var description = ""
		var quality = quality_junk
		var ghosttexture = null
		var cursed = false
		var armor = 0
		var defense = 0
		var axe_power = 0
		var pick_power = 0
		var material = false
		var stamina_cost = 0.0
		var hammer_power = 0
		var active_use = false
		
		if item.has("max_count"):
			maxcount = item.max_count
		if item.has("texture"):
			texture = item.texture
		if item.has("description"):
			description = item.description
		if item.has("on_use"):
			onuse = item.on_use
		if item.has("quality"):
			quality = item.quality
		if item.has("ghost_texture"):
			ghosttexture = item.ghost_texture
		if item.has("cursed"):
			cursed = item.cursed
		if item.has("armor"):
			armor = item.armor
		if item.has("defense"):
			defense = item.defense
		if item.has("axe_power"):
			axe_power = item.axe_power
		if item.has("pick_power"):
			pick_power = item.pick_power
		if item.has("material"):
			material = item.material
		if item.has("stamina_cost"):
			stamina_cost = item.stamina_cost
		if item.has("hammer_power"):
			hammer_power = item.hammer_power
		if item.has("active_use"):
			active_use = item.active_use
		
		
		# correct item
		# check if this item should have a ghost texture
		if ghosttexture != null:
			return Item.new(item_name, load(texture), description, quality, -1, maxcount, load(onuse), load(ghosttexture), cursed, armor, defense, axe_power, pick_power, material, stamina_cost, hammer_power, active_use)
		return Item.new(item_name, load(texture), description, quality, -1, maxcount, load(onuse), null, cursed, armor, defense, axe_power, pick_power, material, stamina_cost, hammer_power, active_use)
		
		
