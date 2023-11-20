extends Node2D


enum Type {
	Surface,
	Dungeon
}


const max_distance : int = 100


export(Type) var type = Type.Surface
export(bool) var override_flag = true
export(int) var health = 25
var can_use : bool = false


func _ready() -> void:
	if type == Type.Dungeon:
		$Sprite.texture = load("res://assets/art/structures/structure_dungeon_hole.png")
		$Sprite.offset.y = 12
	if Game.world_flags.has("dungeon_opened"):
		if Game.world_flags.dungeon_opened and !override_flag:
			_die()
	_update_sprite()


func _update_sprite() -> void:
	if health <= 18:
		$Boards.animation = "boards_damaged"
	if health <= 8:
		$Boards.animation = "boards_broken"
	if health <= 0:
		_die()


func _die() -> void:
	$Boards.visible = false
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	can_use = true
	Game.world_flags["dungeon_opened"] = true


func _mark_world_flag(flag : bool) -> void:
	Game.world_flags["dungeon_opened"] = flag


func _on_hit(area):
	var damage = area._get_damage()
	health -= damage
	_update_sprite()


func _on_ButtonInteract_pressed():
	if can_use and global_position.distance_to(PlayerInventory.player.global_position) <= max_distance:
		Game._save_all()
		Game._create_dungeon()
