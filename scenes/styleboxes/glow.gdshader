shader_type canvas_item;

uniform vec2 rect_size = vec2(290.0, 480.0); // Original rectangle size in pixels
uniform float glow_size = 50.0;    			 // Glow distance in pixels
uniform vec4 color : source_color = vec4(0.0, 0.0, 1.0, 0.5); // Base color

varying vec2 original_UV;       // UV coordinates for distance calculation

void vertex() {
    // Calculate factors based on vertex position relative to the rectangle size
    float x_factor = (VERTEX.x / rect_size.x) * 2.0 - 1.0;
    float y_factor = (VERTEX.y / rect_size.y) * 2.0 - 1.0;

    // Adjust vertex positions to expand the rectangle
    VERTEX.x += x_factor * glow_size;
    VERTEX.y += y_factor * glow_size;

    // Store the UV coordinates relative to the expanded rectangle
    // We'll use these in the fragment shader
    original_UV = (VERTEX.xy - vec2(-glow_size, -glow_size)) / (rect_size + vec2(glow_size * 2.0));
}

void fragment() {
    // Map original_UV back to coordinates relative to the original rectangle
    vec2 uv = original_UV * (rect_size + vec2(glow_size * 2.0)) - vec2(glow_size);

    // Calculate the distance to the original rectangle edges
    vec2 half_size = rect_size * 0.5;
    vec2 rect_center = vec2(0.0, 0.0) + half_size;
    vec2 d = abs(uv - rect_center) - half_size;
    float dist = abs(length(max(d, 0.0)));
    dist += abs(min(max(d.x, d.y), 0.0));

    // Compute alpha based on distance
    float alpha = 1.0 - smoothstep(0.0, glow_size, dist);

    // Set the final color with computed alpha
    COLOR = color;
    //COLOR.a *= alpha * abs(sin(TIME*2.0));
	COLOR.a *= alpha;
}
