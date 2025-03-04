shader_type canvas_item;

uniform vec4 blade_color : source_color = vec4(1.0, 0.2, 0.2, 1.0); // Red Blade
uniform float glow_intensity : hint_range(0.0, 5.0) = 2.0;
uniform float width : hint_range(0.1, 1.0) = 0.5;
uniform float curve_amount : hint_range(0.1, 5.0) = 2.5;
uniform float time_speed : hint_range(0.0, 5.0) = 1.0;

void fragment() {
    vec2 uv = UV * 2.0 - 1.0; // Normalize UV from -1 to 1
    uv.x *= width;

    // Double-sided scythe shape using a sin wave
    float curve = sin(uv.y * curve_amount) * 0.5;
    float blade_mask = smoothstep(0.2, 0.0, abs(uv.x - curve));

    // Add glow effect
    float glow = smoothstep(0.5, 0.1, abs(uv.x - curve)) * glow_intensity;
    
    // Animated energy flicker effect
    float flicker = sin(TIME * time_speed) * 0.1;
    glow += flicker;

    // Final color
    vec4 final_color = blade_color * (blade_mask + glow);
    final_color.a *= blade_mask; // Control transparency

    COLOR = final_color;
}


