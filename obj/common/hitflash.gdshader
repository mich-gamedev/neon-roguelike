shader_type canvas_item;

uniform bool enabled = false;
uniform vec3 flash_color: source_color = vec3(1.0,1.0,1.0);

void fragment() {
	if (enabled == true) {
		COLOR = vec4(flash_color.r, flash_color.g, flash_color.b, COLOR.a);
	}
}
