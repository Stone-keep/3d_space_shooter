shader_type spatial;

uniform float progress: hint_range(0.0, 1.0) = 0.0;

void fragment() {
	ALPHA = progress;
	ALBEDO = vec3(1.0);
}
