extends Area2D

@export var magnet_strength: float = 500.0
@export var distance_falloff: bool = false
@export var draw_debug: bool = false

var collision_shape: CollisionShape2D
var rect_shape: RectangleShape2D

enum State {off, pull, push}
var state: State = State.off

var origin: Vector2

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pull"):
		state = State.pull
	if event.is_action_released("pull"):
		state = State.off
	if event.is_action_pressed("push"):
		state = State.push
	if event.is_action_released("push"):
		state = State.off
		
func _ready() -> void:
	origin = global_position
	collision_shape = get_node("CollisionShape2D")
	if collision_shape and collision_shape.shape is RectangleShape2D:
		rect_shape = collision_shape.shape
	else:
		push_error("Area2D needs a child CollisionShape2D with RectangleShape2D!")

func _physics_process(_delta: float) -> void:
	if not collision_shape or not rect_shape:
		return
	
	var bodies: Array[Node2D] = get_overlapping_bodies()
	for body in bodies:
		if body is RapierRigidBody2D and body.is_in_group("affectable"):
			if(state != State.off):
				apply_magnetic_force(body)

func apply_magnetic_force(body: RapierRigidBody2D) -> void:
	var to_magnet: Vector2 = origin - body.global_position
	var distance: float = to_magnet.length()
	var magnet_force: Vector2 = to_magnet.normalized()
	
	var center_force: Vector2 = magnet_force.slide(global_transform.basis_xform(Vector2.UP))
	center_force *= 100000000.0
	
	if (state == State.push):
		magnet_force *= -1.0
		center_force = Vector2.ZERO
	
	if distance > 0.1:
		var force_magnitude: float = magnet_strength * 1000.0
		
		if distance_falloff:
			var falloff: float = magnet_strength / (distance * distance * 0.0001)
			force_magnitude = max(force_magnitude * 0.1, falloff)
		
		magnet_force = magnet_force * force_magnitude
		body.apply_force(magnet_force + center_force)
		
		
func _draw() -> void:
	if not draw_debug:
		return
	if not collision_shape or not rect_shape:
		return
	
	var rect: Rect2 = Rect2(-rect_shape.size, rect_shape.size)
	
	var rect_transform: Transform2D = Transform2D(collision_shape.rotation, collision_shape.position + rect_shape.size / 2)
	draw_set_transform(rect_transform.origin, rect_transform.get_rotation(), rect_transform.get_scale())
	draw_rect(rect, Color(1, 0.2, 0.2, 0.3), true)
	draw_rect(rect, Color(1, 0, 0, 0.8), false, 2.0)
	

