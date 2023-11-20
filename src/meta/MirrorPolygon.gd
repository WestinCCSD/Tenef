class_name MirrorPolygon
extends CollisionPolygon2D


export(bool) var mirror_x = false
export(bool) var mirror_y = false
export(bool) var debug_visible = false


func _ready() -> void:
	_mirror()
	if debug_visible:
		var visiblepolygon = Polygon2D.new()
		visiblepolygon.polygon = polygon
		add_child(visiblepolygon)


func _mirror() -> void:
	if mirror_x:
		for x in polygon.size():
			polygon[x].x = -(polygon[x].x)
	if mirror_y:
		for y in polygon.size():
			polygon[y].y = -polygon[y].y


func _script_changed() -> void:
	pass
