extends StaticBody2D


func _ready() -> void:
	_shift_position()


func _shift_position() -> void:
	var rand_x = rand_range(-8.0, 8.0)
	$Sprite.position.x += rand_x
	$SpriteKey.position.x += rand_x
	$Sprite.position.y += rand_range(-8.0, 8.0)
	if rand_range(0.0, 1.0) > 0.5:
		$Sprite.flip_h = true


func _on_PlayerCollisionRange_area_entered(area):
	$SpriteKey.show()
	area.get_parent()._queue_interactable_object(self)


func _interact(node : Node) -> void:
	var item = ItemLookup._get_as_item("Stone")
	item.amount = 1
	position += Vector2(24, 24)
	node._spawn_dropped_item(item, position)
	BuildingInfo._remove_building(BuildingInfo._to_grid(position))
	queue_free()


func _on_PlayerCollisionRange_area_exited(area):
	area.get_parent()._dequeue_interactable_object(self)
	$SpriteKey.hide()


func _get_save_data() -> Game.Saveable:
	return Game.Saveable.new(
		"res://scenes/structures/Structure_Stone.tscn",
		 position,
		 {"position": {"x": position.x, "y": position.y}, "rotated": $Sprite.flip_h})


func _load_data(data : Dictionary) -> void:
	position = Vector2(data.position.x, data.position.y)
	$Sprite.flip_h = data.rotated
