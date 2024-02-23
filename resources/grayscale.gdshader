shader_type canvas_item;

void fragment() {
	vec4 bg = texture(TEXTURE, SCREEN_UV);
	float avg = (bg.r + bg.g + bg.b) / 3.0;
	COLOR = vec4(avg, avg, avg, 1.0);
}