shader_type canvas_item;

varying vec4 v_vertex_color;
uniform int amount = 40;

void vertex() {
	v_vertex_color = COLOR;
}

void fragment()
{
	vec2 grid_uv = round(UV * float(amount)) / float(amount);
	
	COLOR = v_vertex_color * texture(TEXTURE, grid_uv);
}