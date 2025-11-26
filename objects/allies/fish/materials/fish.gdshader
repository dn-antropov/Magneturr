shader_type canvas_item;

uniform vec3 color;
uniform vec3 suffering_color;
uniform float suffering_ammount;

void fragment() {
	float alpha = texture(TEXTURE, UV).r;
	COLOR.rgb = mix(color, suffering_color, suffering_ammount);
	COLOR.a = alpha;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
