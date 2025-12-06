extends Area2D

@export var collision_shape: CollisionShape2D
@export var explosion_size: float = 300.
@export var lifespan: int = 15

func _ready() -> void:
	collision_shape.shape.radius = explosion_size
	
func _draw() -> void:
	draw_circle(Vector2(0.,0.), explosion_size, Color(1, 0, 0, 1))
	
func _process(_delta: float) -> void:
	if lifespan <= 0:
		self.queue_free()
	lifespan -= 1
