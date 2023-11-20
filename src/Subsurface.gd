extends YSort


export(bool) var buildable = false


func _ready() -> void:
	$WorldGenerator.world_size = Vector2(32, 32)
	$WorldGenerator.generator = SubsurfaceGenerator.new()
	$WorldGenerator._init_generator()
	yield(get_tree(), "idle_frame")
	$WorldGenerator._generate_world()
	
	# generation finished
	Game._set_player_position()
	$WallPair._pair()
	$Ambience.play()
