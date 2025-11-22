class_name Floatable
extends RapierRigidBody2D

@export var object_density: float = 1.0
@export var water_density: float = 1.0
@export var drag_coefficient: float = 0.01

func _ready() -> void:
	var volume: float = get_volume()
	mass = object_density * volume

func _physics_process(_delta: float) -> void:
	apply_buoyancy()
	apply_water_drag()

func apply_buoyancy() -> void:
	var volume: float = get_volume()
	var displaced_mass: float = water_density * volume
	var object_mass: float = object_density * volume
	var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	
	var net_buoyancy = (displaced_mass - object_mass) * gravity
	var buoyancy: Vector2 = Vector2(0, -net_buoyancy)
	apply_force(buoyancy)

func apply_water_drag() -> void:
	var velocity = linear_velocity
	var speed = velocity.length()
	if speed > 0.001:
		var drag = -velocity.normalized() * drag_coefficient * speed * speed
		apply_force(drag)

	var angular_drag = -angular_velocity * drag_coefficient
	apply_torque(angular_drag)

func get_volume() -> float:
	for child in get_children():
		if child is CollisionShape2D:
			var shape: Shape2D = child.shape
			if shape is CircleShape2D:
				return PI * shape.radius * shape.radius
			elif shape is RectangleShape2D:
				return shape.size.x * shape.size.y
	return 1.0