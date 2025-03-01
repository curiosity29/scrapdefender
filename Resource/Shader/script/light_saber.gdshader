shader_type canvas_item;

uniform float border_color_strength = 0.0;
uniform float border_alpha = 0.0;
uniform float center_width = 0.15;
uniform float light_decay_pow = 0.9;

vec3 rgb2hsv(vec3 c) {
    float c_max = max(c.r, max(c.g, c.b));
    float c_min = min(c.r, min(c.g, c.b));
    float delta = c_max - c_min;

    float h = 0.0;
    if (delta > 0.00001) {
        if (c_max == c.r) {
            h = mod((c.g - c.b) / delta, 6.0);
        } else if (c_max == c.g) {
            h = (c.b - c.r) / delta + 2.0;
        } else {
            h = (c.r - c.g) / delta + 4.0;
        }
        h /= 6.0;
        if (h < 0.0) h += 1.0;
    }

    float s = (c_max > 0.0) ? (delta / c_max) : 0.0;
    float v = c_max;

    return vec3(h, s, v);
}

vec3 hsv2rgb(vec3 _c) {
    vec4 _K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 _p = abs(fract(_c.xxx + _K.xyz) * 6.0 - _K.www);
    return _c.z * mix(_K.xxx, clamp(_p - _K.xxx, 0.0, 1.0), _c.y);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float dist_to_center = max(abs(UV.x - 0.5) - center_width/2.0, 0) ; // 0: 1, 0.5: 0
	float lerp_value = mix(0.0, 1.0, dist_to_center / (0.5 - center_width/2.0));
	float alpha = mix(1, border_alpha, lerp_value);
	float color_strength = pow(mix(1, border_color_strength, lerp_value), light_decay_pow);

	vec3 hsv_color = rgb2hsv(COLOR.rgb);
	hsv_color.z *= color_strength;
	vec3 color = hsv2rgb(hsv_color);

	COLOR = vec4(color, alpha);
	//COLOR = vec4(COLOR.rgb, alpha);

}
