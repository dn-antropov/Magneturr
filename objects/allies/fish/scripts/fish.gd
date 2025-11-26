extends Floatable

@export var thrust_frequency: float = 1.
@export var health: int = 3
@export var Sprite: Sprite2D

var elapsed_time: float = 0.
var suffering: bool = false
var suffering_ammount: float = 0.

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
	
	if suffering:
		suffer(delta)	
		
func thrust() -> void:
	var thrust_force: Vector2 = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
	apply_force(thrust_force * 10000000.)
	
func suffer(delta: float) -> void:
	suffering_ammount += delta
	var suffering_ammount_scaled: float = (sin(suffering_ammount * PI))
	Sprite.material.set_shader_parameter("suffering_ammount", suffering_ammount_scaled)
	if suffering_ammount >= 1.:
		suffering = false
	
func _on_body_entered(body: Node2D) -> void:
	if body.has_node("Harm"):
		health -= body.get_node("Harm").power
		suffering_ammount = 0.
		suffering = true
		
