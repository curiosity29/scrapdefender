shader_type canvas_item;

uniform float pog_value: hint_range(0.0, 1.0, 0.1);
uniform vec4 min_color: source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 max_color: source_color = vec4(0.0, 1.0, 0.0, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	COLOR.rgb = mix(min_color, max_color, pog_value).rgb;
	COLOR.a = 1.0 - step(pog_value, UV.x);
	
	
	// Called for every pixel the material is visible on.
}
