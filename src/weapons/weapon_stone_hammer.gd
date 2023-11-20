extends Node2D


func _ready() -> void:
	rotation = get_local_mouse_position().angle()
	var player = PlayerInventory.player
	if player != null:
		if player.stam >= 5.0:
			player._remove_stamina(5.0)
			$Anims.play("Swing")
		else:
			queue_free()


func _on_anim_finish(_anim_name):
	queue_free()
