extends Node2D

export(int) var max_health = 20
var health : int = max_health
# this is how much damage needs to be done in order for a stone to be dropped
var checkpoint : int = 10
# how many checkpoints have been passed thus far
var checkpoints : int = 0

var particles : PackedScene = load("res://scenes/structures/Structure_Boulder_Particle.tscn")

var origin : Vector2 = Vector2.ZERO

func _ready():
	origin = position
	position.x += rand_range(-8.0, 8.0)
	position.y += rand_range(-8.0, 8.0)
	if randf() >= 0.5:
		$Boulder.flip_h = true


func _on_hit(area):
	health -= area._get_damage()
	var instance = particles.instance()
	add_child(instance)
	# find the amount of missing health this boulder has
	var missing_health : int = max_health - health
	# find how many checkpoints have been passed with this amount of missing health
	var crossed_checkpoints : int = floor(missing_health / checkpoint)
	# subtract by the amount of checkpoints already passed
	# if a new checkpoint has been passed, spawn a stone
	if crossed_checkpoints - checkpoints != 0:
		checkpoints += 1
		_drop_stone()
	if health <= 0:
		_drop_stone()
		BuildingInfo._remove_building(BuildingInfo._to_grid(origin))
		queue_free()


func _drop_stone() -> void:
	var item = ItemLookup._get_as_item("Stone")
	item.amount = 1
	get_tree().call_group("player", "_spawn_dropped_item", item, position)


func _get_save_data() -> Game.Saveable:
	return Game.Saveable.new(
		"res://scenes/structures/Structure_Boulder.tscn",
		 position,
		 {"health": health, "position": {"x": position.x, "y": position.y}, "rotated": $Boulder.flip_h})


func _load_data(prevdata : Dictionary) -> void:
	health = prevdata.health
	position = Vector2(prevdata.position.x, prevdata.position.y)
	$Boulder.flip_h = prevdata.rotated
