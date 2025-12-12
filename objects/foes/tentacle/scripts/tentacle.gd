@tool
extends Node2D
class_name Tentacle

@export var vectorShape: ScalableVectorShape2D
@export var skeleton: Skeleton2D
	
func _process(delta: float) -> void:
	smooth_curve_catmull_rom(vectorShape.curve, 0.1)
	# vectorShape.curve.set_point_position(0, vectorShape.curve.get_point_position(0) + Vector2(1,1))

static func smooth_curve_catmull_rom(curve: Curve2D, tension: float = 0.5) -> void:
	var point_count = curve.get_point_count()
	if point_count < 2: return

	for i in range(point_count):
		var p_prev = curve.get_point_position(max(0, i - 1))
		var p_curr = curve.get_point_position(i)
		var p_next = curve.get_point_position(min(point_count - 1, i + 1))
		var p_next_next = curve.get_point_position(min(point_count - 1, i + 2))

		# Catmull-Rom logic: Tangent is (Next - Prev) * tension
		var tangent = (p_next - p_prev) * tension		
		var d1 = p_next - p_prev
		
		# For point i, the tangent vector is roughly parallel to (next - prev)
		curve.set_point_in(i, -d1 * tension)
		curve.set_point_out(i, d1 * tension)