extends Node2D

func _process(_delta: float):
	look_at(get_global_mouse_position())
	rotate(PI * 0.5)
