class_name SelfDestructTimer
extends Timer


signal destroyed(target)


export(NodePath) var target


func _ready() -> void:
	connect("timeout", self, "_timeout")
	one_shot = true


func _timeout() -> void:
	emit_signal("destroyed", target)
	var node = get_node(target)
	node.queue_free()
