extends Floatable

@export var detonation_impulse: float = 2000000.
const _explosion = preload("res://objects/foes/explosion/explosion.tscn")

func _ready() -> void:
	super._ready()
	contact_monitor = true
	max_contacts_reported = 4
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(_body: Node2D) -> void:
	return
	
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	for i in range(state.get_contact_count()):
		if state.get_contact_impulse(i).length() >= detonation_impulse:
			var explosion = _explosion.instantiate()
			get_parent().add_child(explosion)
			explosion.global_position = self.global_position
			self.queue_free()
			