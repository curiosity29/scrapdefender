shader_type canvas_item;

uniform vec2 first_point = vec2(0.4, 0.2);
uniform vec2 second_point = vec2(0.6, 0.8);
uniform float min_dist_mult = 0.4;
uniform float max_dist_mult = 0.4;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV.xy;
	
	vec2 dist2points = vec2(length(uv-first_point), length(uv-second_point));
	float min_dist = min(dist2points.x, dist2points.y);
	float max_dist = max(dist2points.x, dist2points.y);
	float alpha = min_dist * min_dist_mult - max_dist * max_dist_mult - 0.5;
	COLOR.a = alpha;
	
	// Called for every pixel the material is visible on.
}

