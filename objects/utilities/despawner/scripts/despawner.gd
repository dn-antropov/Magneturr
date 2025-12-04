extends Area2D

@export var spawner: Spawner

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	body.queue_free()
	spawner.spawn_mine()