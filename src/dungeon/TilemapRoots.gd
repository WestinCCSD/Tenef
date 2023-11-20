extends TileMap


class RootHealth:
	var m_cell = Vector2.ZERO
	var m_health = 0
	
	func _init(p_cell, p_health) -> void:
		m_cell = p_cell
		m_health = p_health


const ParticlesScene : PackedScene = preload("res://scenes/structures/Structure_Root_Particle.tscn")


export(float) var max_distance = 50.0
export(int) var health = 3 # health per root
export(int) var min_axe_power = 1


var damaged_roots : Array = []


func _get_cell(p_cell) -> RootHealth:
	for root in damaged_roots:
		var cell : Vector2 = root.m_cell
		if cell.is_equal_approx(p_cell):
			return root
	return null


func _near_cell(cell : Vector2, player : Node2D) -> bool:
	var cellpos = map_to_world(cell)
	cellpos.x += 24
	cellpos.y += 24
	return cellpos.distance_to(player.global_position) <= max_distance


func _tile_destroyed(tile : Vector2, player : Node2D) -> void:
	var item : Item 
	var rand = randf()
	var spawn_item : bool = false
	if rand < 0.05:
		spawn_item = true
		item = ItemLookup._get_as_item("Lumber")
	elif rand < 0.5:
		spawn_item = true
		item = ItemLookup._get_as_item("Wood")
	var pos : Vector2 = map_to_world(tile)
	pos.x += 24
	pos.y += 24
	if spawn_item:
		item.amount = 1
		player._spawn_dropped_item(item, pos)
	AI._set_navigation_tile(tile.x, tile.y, 0)


# use a group and a notification system that way we can avoid weird issues with priority
func _notify_player_use(item : Item) -> void:
	var player = PlayerInventory.player
	if player == null:
		return
	var tile : Vector2 = world_to_map(get_global_mouse_position())
	if get_cell(tile.x, tile.y) != -1 and item.axe_power >= min_axe_power and _near_cell(tile, player):
		_spawn_particles()
		var cell = _get_cell(tile)
		if cell == null:
			damaged_roots.push_back(RootHealth.new(tile, health - item.axe_power))
			return
		else:
			cell.m_health -= item.axe_power
		if cell.m_health > 0:
			return
		set_cell(tile.x, tile.y, -1)
		update_bitmask_area(tile)
		_tile_destroyed(tile, player)


func _spawn_particles() -> void:
		var particles = ParticlesScene.instance()
		particles.global_position = get_global_mouse_position()
		add_child(particles)
	
