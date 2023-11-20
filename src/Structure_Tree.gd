extends Node2D

enum type { sand, grass }

export(int) var health = 12
export(type) var tree_type = type.sand

var destroyed : bool = false

# possible optimization. not every tree needs a copy of this scene
var particles : PackedScene = load("res://scenes/structures/Structure_Tree_Particle.tscn")
var collapsed_tree : PackedScene = load("res://scenes/structures/Collapsed_Tree.tscn")

func _ready() -> void:
	_shift_position()
	_update_texture()
	$Animations.play("sway", -1, rand_range(0.8, 1.1))


func _update_texture() -> void:
	if tree_type == type.grass:
		$Base.texture = load("res://assets/art/structures/structure_palmtree_whole_grass.png")
	else:
		$Base.texture = load("res://assets/art/structures/structure_palmtree_whole_sand.png")


func _shift_position() -> void:
	position.x += rand_range(8.0, 8.0)
	position.y += rand_range(-8.0, 8.0)


func _on_hit(area):
	var instance = particles.instance()
	add_child(instance)
	health -= area._get_damage()
	if health <= 0:
		_destroy()


func _destroy() -> void:
	# tree destroyed! #
		if randf() > 0.5:
			var item = ItemLookup._get_as_item("Lumber")
			item.amount = 1
			get_tree().call_group("player", "_spawn_dropped_item", item, Vector2(position.x, position.y + 24))
		# swap texture and spawn tree particle
		destroyed = true
		$Base/Leaves.hide()
		$Base.texture = load("res://assets/art/structures/structure_palmtree_stump_sand.png")
		$Base.offset.y = 60
		$LeafParticle.emitting = true
		# disable this tree from being whacked again
		$Base/HarvestBox/HarvestShape.set_deferred("disabled", true)
		# spawn collapsed tree
		var collapsed_instance = collapsed_tree.instance()
		call_deferred("add_child", collapsed_instance)


func _on_Animations_animation_finished(anim_name):
	if anim_name == "sway":
		$Animations.play("sway", -1, rand_range(0.8, 1.1))


func _get_save_data() -> Game.Saveable:
	return Game.Saveable.new(
		"res://scenes/structures/Structure_Tree.tscn",
		Vector2.ZERO,
		{
			"health": health, 
			"type": tree_type,
			"destroyed": destroyed,
			"position": {"x": position.x, "y": position.y}
		}
	)


func _load_data(data : Dictionary) -> void:
	position = Vector2(data.position.x, data.position.y)
	health = data.health
	tree_type = data.type
	destroyed = data.destroyed
	_update_texture()
	if destroyed:
		$Base/Leaves.hide()
		$Base.texture = load("res://assets/art/structures/structure_palmtree_stump_sand.png")
		$Base.offset.y = 60
		$Base/HarvestBox/HarvestShape.set_deferred("disabled", true)
