extends Node2D


export(int) var restore_amount = 20
export(float) var stamina_rate = 2.0
var can_stop : bool = true


func _ready() -> void:
	PlayerInventory.player._play_animation("open")
	$StartupTimer.start()


func _physics_process(delta):
	PlayerInventory.player._add_stamina(stamina_rate * delta)


func _startup_finished() -> void:
	_drink()


func _drink() -> void:
	can_stop = false
	PlayerInventory.player._play_animation("drink")
	PlayerInventory.player._change_health(restore_amount)
	$DrinkEffect.play()
	$DrinkTimer.start()
	
	var item = ItemLookup._get_as_item("Small Health Potion")
	item.amount = 1
	PlayerInventory.player._remove_item(item)


func _cancel_use() -> void:
	if can_stop:
		queue_free()


func _finish_drink() -> void:
	can_stop = true
	_cancel_use()


func _self_destruct() -> void:
	_cancel_use()
