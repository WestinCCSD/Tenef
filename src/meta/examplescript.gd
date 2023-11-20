class ClassName:
	var name : String = "class"
	
	func _init(p_name : String) -> void:
		name = p_name
	
	
	func _set_name(p_name : String) -> void:
		name = p_name
	
	func _get_name() -> String:
		return name



func _get_class() -> ClassName:
	var object : ClassName = ClassName.new("lol")
	object._set_name(object._get_name() + " lolx2")
	return object
