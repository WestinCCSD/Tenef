extends Node2D


export(float) var blocking_power = 0.35


var player : Node2D = null


func _fetch_player() -> void:
	if get_tree().has_group("player"):
		player = get_tree().get_nodes_in_group("player")[0]


func _ready() -> void:
	_fetch_player()
	if player != null:
		_flip(player.direction)
		player._play_animation("defend")
		player.blocking_power = blocking_power
		_enable_blocking()


func _physics_process(delta) -> void:
	if player != null:
		_flip(player.direction)
		player._add_stamina(1.5 * delta)
		if !player.stunned and player.blocking and player.alive:
			player._play_animation("defend")


func _enable_blocking() -> void:
	if player != null:
		player.blocking = true


func _cancel_use() -> void:
	if player != null:
		player.blocking = false
		player.blocking_power = 0.0
		queue_free()


func _flip(dir : bool) -> void:
	if !dir:
		$Sprite.position = Vector2(16, -16)
	else:
		$Sprite.position = Vector2(-16, -16)
