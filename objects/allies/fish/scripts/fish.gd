extends Floatable

@export var thrust_frequency: float = 1.

var elapsed_time: float = 0.

func _ready() -> void:
	super._ready()
	contact_monitor = true
	max_contacts_reported = 4
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if elapsed_time >= thrust_frequency:
		thrust()
		elapsed_time = 0.
	
	elapsed_time += delta
	
	if linear_velocity.x > 0.:
		get_node("Sprite2D").flip_h = true;
	else:
		get_node("Sprite2D").flip_h = false;		
		
func thrust() -> void:
	var thrust_force: Vector2 = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
	apply_force(thrust_force * 1000000.)
	
func _on_body_entered(body: Node2D) -> void:
	print(body.name)