shader_type canvas_item;

uniform float pog_value: hint_range(0.0, 1.0, 0.1);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.a = 1.0 - step(pog_value, UV.x);
	
	
	// Called for every pixel the material is visible on.
}
