extends Node2D


signal animation_over


export(int) var base_y = -700
export(float) var landing_y = -10.0
export(float) var fall_speed = 1000.0

var landed : bool = false
var can_fall : bool = false


func _ready() -> void:
	$Player.position.y = base_y
	$Fall.play()


func _process(delta):
	if !landed and can_fall:
		$Player.position.y += fall_speed * delta
		if $Player.position.y >= landing_y:
			$Player.position.y = landing_y
			_stop()


func _stop() -> void:
	$Player.texture = load("res://assets/art/player/hobo_dead.png")
	$DustParticles.emitting = true
	$EndTimer.start()
	$Crash.play()
	landed = true


func _start_falling():
	$Anims.play("shrink")
	can_fall = true


func _animation_over() -> void:
	emit_signal("animation_over")
