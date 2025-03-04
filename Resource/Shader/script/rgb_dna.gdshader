shader_type canvas_item;

uniform vec2 strand_width = vec2(0.2, 0.2); // Thickness of the wave
uniform float travel_speed = 8.0; // Speed of the wave
uniform float frequency = 20.0;  // Frequency of the sine wave
uniform float amplitude = 0.4;  // Amplitude of the sine wave
uniform float y_speed = 1.0;    // Vertical speed of the wave

uniform vec4 color_1 : source_color = vec4(1.0, 0.3, 0.3, 1.0); // Primary color
uniform vec4 color_2 : source_color = vec4(0.3, 1.0, 1.0, 1.0); // Secondary color

uniform vec4 color_3 : source_color = vec4(0.3, 1.0, 0.3, 1.0); // Secondary color
uniform vec4 color_4 : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Primary color

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

void fragment() {
    vec2 uv = UV;
		
	//vec4 rgb_color_1 = vec4(hsv2rgb(color_1.rgb), color_1.a);
	//vec4 rgb_color_2 = vec4(hsv2rgb(color_1.rgb), color_1.a);
	//vec4 rgb_color_3 = vec4(hsv2rgb(color_1.rgb), color_1.a);
	//vec4 rgb_color_4 = vec4(hsv2rgb(color_1.rgb), color_1.a);
	//float rgb_color_2.rgb = hsv2rgb(color_2.rgb);
	//
	//float rgb_color_3.rgb = hsv2rgb(color_1.rgb);
	//float rgb_color_4.rgb = hsv2rgb(color_2.rgb);
	
	float y_based_amplitude = amplitude * sin(uv.y * TAU * 3.0);
	float y2_based_amplitude = amplitude * sin(uv.y * TAU * 3.0);
    
    // Calculate the sine wave motion along the X-axis
    float wave = y_based_amplitude * sin(frequency * uv.y + TIME * travel_speed);
	float wave2 = -y2_based_amplitude * sin(frequency * uv.y + TIME * travel_speed);
    // Distance from the sine wave center
    float dist_to_wave = abs(uv.x - 0.5 - wave);
	float dist_to_wave2 = abs(uv.x - 0.5 - wave2);

    // Smooth transition for the wave effect
    float alpha = smoothstep(strand_width.x, 0.0, dist_to_wave);
	float alpha2 = smoothstep(strand_width.x, 0.0, dist_to_wave2);
    // Blend between two colors
    vec3 final_color = mix(color_1.rgb, color_2.rgb, pow(alpha, 2.0));
	vec3 final_color2 = mix(color_3.rgb, color_4.rgb, pow(alpha2, 2.0));
	
	
	float final_alpha = max(alpha, alpha2);
	if (alpha <= alpha2) {
		final_color = mix(final_color, final_color2, alpha/alpha2);
		COLOR = vec4(final_color, final_alpha);
	}
	else {
		final_color = mix(final_color2, final_color, alpha2/alpha);
		COLOR = vec4(final_color, final_alpha);
	}
    // Output final color with smooth transparency
    
}