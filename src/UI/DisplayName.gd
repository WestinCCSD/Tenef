extends Node2D


func _process(_delta):
	global_position = get_global_mouse_position()


func _set_name(new_name) -> void:
	$Name.text = new_name
