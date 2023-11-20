extends CanvasLayer


signal faded
signal faded_out
signal faded_in


func _ready() -> void:
	$Box.hide()


func _play(animation : String) -> void:
	$Box.show()
	$Anims.play(animation)


func _on_anim_finished(anim_name):
	emit_signal("faded")
	if anim_name.hash() == "out".hash():
		emit_signal("faded_out")
		$Box.hide()
	else:
		$Box.show()
		emit_signal("faded_in")
