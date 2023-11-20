extends Node


class Stat:
	var name : String = ""
	var level : int = 0
	
	
	func _calculate(x : int = level) -> float:
		return float(x)


class StaticStat extends Stat:
	func _init(plevel : int = 0) -> void:
		level = plevel
		_ready()
	
	func _ready() -> void:
		pass

class Health extends StaticStat:
	func _ready() -> void:
		name = "Health"
	
	func _calculate(x : int = level) -> float:
		return ceil(sqrt(pow(x + 8, 3))) # sqrt((x + 8)^3)

class Vitality extends StaticStat:
	func _ready() -> void:
		name = "Vitality"
	
	
	# returns max stamina
	func _calculate(x : int = level) -> float:
		return float((x + 4) * 4)
	
	
	func _calculate_regen(x : int = level) -> float:
		return ((float(x) / 1.5) + 6.0)

class Strength extends StaticStat:
	func _ready() -> void:
		name = "Strength"

class Agility extends StaticStat:
	func _ready() -> void:
		name = "Agility"


