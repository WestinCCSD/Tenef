extends "res://src/enemies/Enemy.gd"


export(int) var maxhp = 10
var hp : float = maxhp

var attacking : bool = false

export(float) var movement_speed = 100.0
export(float) var acceleration = 35.0
export(float) var attack_range = 64.0


func _init() -> void:
	knockback_weakness = 1.25


func _ready() -> void:
	._ready()


func _physics_process(_delta) -> void:
	if player != null:
		if global_position.distance_to(player.global_position) <= attack_range and can_attack:
			_attack()


func _attack() -> void:
	can_attack = false
	$Sprite.offset = Vector2(8, -12)
	$Sprite.play("windup")
	$WinddupTimer.start()


func _winddup_over() -> void:
	$Hitbox/CollisionShape2D.set_deferred("disabled", false)
	$Sprite.play("swing")
	$SwingTimer.start()


func _attack_over() -> void:
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)
	attacking = false
	can_attack = true

