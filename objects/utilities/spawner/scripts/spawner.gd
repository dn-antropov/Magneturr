@tool
extends Area2D
class_name Spawner

@export var _mine: Resource
@export var collision: CollisionShape2D
@export var spawnAreaSize: Vector2i:
	set(new_setting):
		spawnAreaSize = new_setting
		if not Engine.is_editor_hint():
			return
		collision.shape.size = spawnAreaSize

func _ready() -> void:
	collision.shape.size = spawnAreaSize
	print(collision.shape.size)

func spawn_mine() -> void:
	var mine = _mine.instantiate()
	get_parent().add_child(mine)
	mine.global_position = Vector2(randf_range(self.global_position.x - collision.shape.size.x / 2,
												self.global_position.x + collision.shape.size.x / 2),
									randf_range(self.global_position.y - collision.shape.size.y/ 2,
												self.global_position.y + collision.shape.size.y / 2))
	print(mine.global_position)
	print(collision.shape.size)
