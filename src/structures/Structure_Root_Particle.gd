extends Particles2D


func _ready() -> void:
	$Selfdestruct.start(lifetime)


func _on_timeout() -> void:
	queue_free()
