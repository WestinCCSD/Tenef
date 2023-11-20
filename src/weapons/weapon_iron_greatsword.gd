extends Node2D


const particles : PackedScene = preload("res://scenes/weapons/DirtParticles.tscn")


export(float) var charge_speed = 200
export(float) var max_charge = 100
export(float) var swing_speed = 1000.0
export(int) var swing_length = 45
var charge : float = 0.0
var swinging : bool = false
var delta_time : float = 0.0

var player : Node = null


func _ready() -> void:
	player = PlayerInventory.player
	$WindupSound.play()
	if player.stam < 8.0:
		queue_free()


func _process(delta):
	delta_time = delta
	if swinging:
		return
	else:
		player._add_stamina(2.0 * delta)
		player._play_animation("hold")
		if player.direction:
			$Sword.rotation_degrees = (-45.0 + charge)
		else:
			$Sword.rotation_degrees = (-45.0 - charge)
		charge += charge_speed * delta
		charge = clamp(charge, -max_charge, max_charge)


func _cancel_use() -> void:
	if is_equal_approx(charge, max_charge) and !swinging:
		_swing()
	else:
		queue_free()


func _swing() -> void:
	var sound = TemporarySound.new()
	sound.stream = load("res://assets/sound/greatsword.ogg")
	sound.autoplay = true
	sound.volume_db = 4.0
	get_parent().add_child(sound)
	var polarity = 0
	if player.direction:
		polarity = -1
	else:
		polarity = 1
		
	var instance = particles.instance()
	instance.emitting = true
	instance.position.x += 64 * polarity
	get_parent().add_child(instance)
	
	swinging = true
	player._play_animation("swing_mighty")
	player._play_effect("quake")
	
	$Effect/Hitbox/CollisionShape2D.set_deferred("disabled", false)
	if !player.direction:
		$Effect/Hitbox.position.x = -6.0
	
	$Sword.position = Vector2(20, (22 * polarity))
	if player.direction:
		$Sword.rotation_degrees = 80.0
	else:
		$Sword.rotation_degrees = -160.0
	$Sword.scale.y = 1.9
	
	$Effect.flip_h = player.direction
	$Effect.show()
	
	$Timer.start(swing_length * delta_time)
	player._remove_stamina(8.0)


func _self_destruct() -> void:
	queue_free()
