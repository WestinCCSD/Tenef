extends StaticBody2D


export(int) var health = 35
export(int) var minimum_axe_power = 2
export(bool) var debug_die = false


func _ready() -> void:
	_flip(randf() <= 0.5)
	var vec : Vector2 = Vector2(rand_range(-4.0, 4.0), rand_range(-4.0, 4.0))
	_offset(vec)
	if debug_die:
		_die()


func _flip(flip : bool) -> void:
	$Base.flip_h = flip
	$Stalk.flip_h = flip


func _offset(vec : Vector2) -> void:
	$Base.offset = vec
	$Stalk.offset = vec


func _on_hit(area) -> void:
	if PlayerInventory._get_selected_item().axe_power >= minimum_axe_power:
		var damage = area._get_damage()
		health -= damage
		var particles = load("res://scenes/structures/Structure_Root_Particle.tscn").instance()
		particles.position = Vector2(28.0, 24.0) + $Base.offset
		add_child(particles)
		particles.emitting = true
		if health <= 0:
			_die()


func _die() -> void:
	$Base.texture = load("res://assets/art/structures/structure_root_tall_cut.png")
	$Stalk.texture = load("res://assets/art/structures/structure_root_hang.png")
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	_spawn_loot()


func _spawn_loot() -> void:
	var item = ItemLookup._get_as_item("Root")
	var amount = randi() % 2
	amount += 1
	item.amount = amount
	PlayerInventory.player._spawn_dropped_item(item, position)
