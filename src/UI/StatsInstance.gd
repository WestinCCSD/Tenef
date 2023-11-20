class_name StatsInstance
extends Node


export(NodePath) var parent = null
export(NodePath) var label = null


var parent_node : Node = null
var label_node : Node = null


func _ready() -> void:
	if parent == null or label == null:
		print("Must have parent and label nodes!")
		return
	parent_node = get_node(parent)
	label_node = get_node(label)
	
	_reset()


func _reset() -> void:
	_get_stats()


func _get_stats() -> Array:
	if PlayerInventory.player == null:
		print("Cannot find player!")
		return []
	var player = PlayerInventory.player
	
	var arr = []
	
	return arr
