class_name Enemy
extends KinematicBody2D


export(NodePath) var sprite = null
export(NodePath) var knockback_timer = null


var stunned : bool = false
var alive : bool = true
var can_attack : bool = true

# whether or not this enemy has detected the player
var alerted : bool = false
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var knockback_velocity = Vector2.ZERO
var path : Array = []
var navigation : Navigation2D = null
var player : Node2D = null

var knockback_weakness : float = 1.0


func _ready() -> void:
	yield(get_tree(), "idle_frame")
	if get_tree().has_group("level_navigation"):
		navigation = get_tree().get_nodes_in_group("level_navigation")[0]
	if get_tree().has_group("player"):
		player = get_tree().get_nodes_in_group("player")[0]


func _update_navigation() -> void:
	if player != null and navigation != null:
		path = navigation.get_simple_path(global_position, player.global_position, false)


func _orient() -> void:
	# find next point
	if path.size() > 0:
		# set direction
		direction = global_position.direction_to(path[1])
		direction = direction.normalized()
		if global_position == path[0]:
			path.pop_front()


func _knockback(power : int, length : float) -> void:
	knockback_velocity = -position.direction_to(player.position)
	knockback_velocity *= power * knockback_weakness
	if knockback_timer != null:
		get_node(knockback_timer).start(length * knockback_weakness)
	stunned = true


func _enable_monochrome() -> void:
	if sprite != null:
		var node = get_node(sprite)
		node.material = ShaderMaterial.new()
		node.material.shader = load("res://src/shaders/monochrome_shader.gdshader")


func _create_damage_number(p_damage : int) -> void:
	var number_scene : PackedScene = load("res://scenes/enemies/DamageNumber.tscn")
	var instance = number_scene.instance()
	instance.position = position
	instance._set_text(str(p_damage))
	get_parent().add_child(instance)

