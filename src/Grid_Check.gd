extends Sprite


var buildable : bool = true
var space_available : bool = false


func _ready() -> void:
	if get_tree().has_group("level"):
		buildable = get_tree().get_nodes_in_group("level")[0].buildable


func _physics_process(_delta) -> void:
	if get_tree().has_group("tilemap_topmost"):
		var tilemap : TileMap = get_tree().get_nodes_in_group("tilemap_topmost")[0]
		position = tilemap.world_to_map(get_global_mouse_position()) * tilemap.cell_size.x
		if $CollisionCheck.get_overlapping_bodies().size() == 0 and buildable:
			space_available = true
		else:
			space_available = false
	if space_available:
		material.set_shader_param("green", true)
		material.set_shader_param("red", false)
	else:
		material.set_shader_param("green", false)
		material.set_shader_param("red", true)
		
