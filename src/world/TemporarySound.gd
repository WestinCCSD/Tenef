class_name TemporarySound
extends AudioStreamPlayer


func _ready() -> void:
	connect("finished", self, "_sound_finished")


func _sound_finished() -> void:
	queue_free()
