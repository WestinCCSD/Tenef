tool
extends Sprite


const base_texture : Texture = preload("res://assets/art/player/hobo_idle.png")
export(Texture) var texture_hint = null


func _process(delta) -> void:
	if texture_hint != null:
		texture = texture_hint
	else:
		texture = base_texture
