@tool
extends Node2D
class_name Tentacle

@export var target: Node2D:
	set(value):
		target = value
		var skeleton: Skeleton2D = get_node("Skeleton2D")
		var modification: SkeletonModification2DFABRIK = skeleton.get_modification_stack().get_modification(0) 
		modification.set_target_node(target.get_path())
		
		
func _ready() -> void:
	var skeleton: Skeleton2D = get_node("Skeleton2D")
	var modification: SkeletonModification2DFABRIK = skeleton.get_modification_stack().get_modification(0) 
	modification.set_target_node(target.get_path())