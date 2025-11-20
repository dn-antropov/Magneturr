extends Area2D

@export var magnet_strength: float = 500.0
@export var distance_falloff: bool = false

var collision_shape: CollisionShape2D
var rect_shape: RectangleShape2D

func _ready() -> void:
	collision_shape = get_node("CollisionShape2D")
	if collision_shape and collision_shape.shape is RectangleShape2D:
		rect_shape = collision_shape.shape
	else:
		push_error("Area2D needs a child CollisionShape2D with RectangleShape2D!")

func _physics_process(_delta: float) -> void:
	if not collision_shape or not rect_shape:
		return
	
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	var max_distance = rect_shape.size.x * collision_shape.scale.x  # Length from shape
	var distance = min(global_position.distance_to(mouse_pos), max_distance)
	
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body is RapierRigidBody2D:
			apply_magnetic_force(body)

func apply_magnetic_force(body: RapierRigidBody2D) -> void:
	var to_magnet = global_position - body.global_position
	var distance = to_magnet.length()
	
	if distance > 0.1:
		var force_magnitude = magnet_strength
		
		if distance_falloff:
			force_magnitude = magnet_strength / (distance * 0.1 + 1.0)
		
		var force = to_magnet.normalized() * force_magnitude
		body.apply_force(force)

func _draw() -> void:
	if not collision_shape or not rect_shape:
		return
	
	var rect = Rect2(-rect_shape.size * collision_shape.scale, rect_shape.size * collision_shape.scale)
	
	var transform = Transform2D(collision_shape.rotation, collision_shape.position + rect_shape.size * collision_shape.scale / 2)
	
	draw_set_transform(transform.origin, transform.get_rotation(), transform.get_scale())
	draw_rect(rect, Color(1, 0.2, 0.2, 0.3), true)
	draw_rect(rect, Color(1, 0, 0, 0.8), false, 2.0)
