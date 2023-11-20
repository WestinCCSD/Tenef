# class used for objects that are supposed to be saved to disk
# trees, rocks, placed buildings, etc.
class Saveable:
	# saved data
	var instance_path : String = "res://" # for reinstantiating this object
	var position : Vector2 = Vector2.ZERO # position to be reinstatiated at
	var data : Dictionary = {} # for holding any custom data
	
	
	func _init(p_path : String, p_position : Vector2, p_data : Dictionary) -> void:
		instance_path = p_path
		position = p_position
		data = p_data
	
	func _to_dict() -> Dictionary:
		var ret = {
			"instance_path": instance_path,
			"position_x": position.x,
			"position_y": position.y,
			"data": data,
		}
		
		return ret
	
	func _print() -> void:
		print(str(self) + ": [" + instance_path + "], [" + str(position) + "], [" + str(data) + "]")
	
