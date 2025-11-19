class_name Mine
extends RapierRigidBody2D

@export var object_density: float = 600.0  # Wood floats
@export var water_density: float = 1000.0
@export var drag_coefficient: float = 1.0

func _ready() -> void:
	# Calculate mass based on volume and density
	var volume = get_volume()
	mass = object_density * volume

func _physics_process(delta: float) -> void:
	apply_buoyancy()
	apply_water_drag()

func apply_buoyancy() -> void:
	var volume = get_volume()
	var displaced_mass = water_density * volume
	var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	
	# Upward buoyancy force
	var buoyancy = Vector2(0, -gravity * displaced_mass)
	apply_force(buoyancy)

func apply_water_drag() -> void:
	# Linear drag
	var velocity = linear_velocity
	var speed = velocity.length()
	if speed > 0.001:
		var drag = -velocity.normalized() * drag_coefficient * speed * speed
		apply_force(drag)
	# Angular drag
	var angular_drag = -angular_velocity * drag_coefficient * 5.0
	apply_torque(angular_drag)

func get_volume() -> float:
	for child in get_children():
		if child is CollisionShape2D:
			var shape = child.shape
			if shape is CircleShape2D:
				return PI * shape.radius * shape.radius
			elif shape is RectangleShape2D:
				return shape.size.x * shape.size.y
			elif shape is CapsuleShape2D:
				var radius = shape.radius
				var height = shape.height
				# Approximate capsule as circle + rectangle
				return PI * radius * radius + (height - radius * 2) * radius * 2
	return 1.0  # Default