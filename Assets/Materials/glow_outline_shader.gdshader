shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform float outline_width : hint_range(0.0, 10.0) = 2.0;

void fragment() {
	vec2 texel_size = vec2(1.0) / TEXTURE_PIXEL_SIZE;
	vec4 tex_color = texture(TEXTURE, UV);
	vec4 outline = vec4(0.0);

	// Check neighboring pixels for alpha values
	for (int x = -1; x <= 1; x++) {
		for (int y = -1; y <= 1; y++) {
			vec2 offset = vec2(float(x), float(y)) * texel_size * outline_width;
			vec4 sample = texture(TEXTURE, UV + offset);
			if (sample.a < 0.1) {
				outline = outline_color;
			}
		}
	}

	// Mix the outline with the original texture
	COLOR = tex_color + outline * (1.0 - tex_color.a);
}