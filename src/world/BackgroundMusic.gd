class_name BackgroundMusic
extends AudioStreamPlayer


signal request_music(node)
signal start_buffer(node)
signal audio_finished(node)


# time is in minutes
export(float) var minimum_buffer_time = 1.0
export(float) var maximum_buffer_time = 1.0


func _ready() -> void:
	self.connect("finished", self, "_audio_finished")
	self.connect("request_music", Game, "_request_background_music")
	self.connect("start_buffer", Game, "_start_background_music_buffer")
	self.add_to_group("background_music")
	call_deferred("emit_signal", "start_buffer", self)


func _request_music() -> void:
	emit_signal("request_music", self)


func _audio_finished() -> void:
	emit_signal("start_buffer", self)
