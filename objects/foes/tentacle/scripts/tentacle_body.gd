@tool
extends Polygon2D

@export var height: int:
	set(value):
		height = value
		redraw_polygon()
@export var width: int:
	set(value):
		width = value
		redraw_polygon()
		
@export var grid_size: int:
	set(value):
		grid_size = value
		redraw_polygon()

var _new_polygon:  PackedVector2Array
func redraw_polygon():
	_new_polygon.clear()
	for h in range(0, height):
		_new_polygon.append(Vector2(0, h * grid_size))
	for w in range(1, width-1):
		_new_polygon.append(Vector2(w * grid_size, (height - 1) * grid_size))
	for h in range(1, height):
		print(h)
		_new_polygon.append(Vector2((width - 1) * grid_size, (height - h) * grid_size))
	for w in range(1, width):
		_new_polygon.append(Vector2((width - w) * grid_size, 0))
	
	set_polygon(_new_polygon)