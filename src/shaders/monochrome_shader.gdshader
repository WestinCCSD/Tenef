shader_type canvas_item;

uniform float brightness = 0.f;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	float color_avg = (color.r + color.g + color.b) / 3.f;
	color.r = color_avg + brightness;
	color.g = color_avg + brightness;
	color.b = color_avg + brightness;
	COLOR = color;
}
