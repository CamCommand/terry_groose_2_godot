shader_type canvas_item;

uniform float glow_strength : hint_range(0.0, 2.0) = 0.3;
uniform float pulse_speed : hint_range(0.0, 10.0) = 2.0;
uniform vec4 glow_color : source_color = vec4(0.878, 0.765, 0.008, 1.0);

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    // Distance from center (0.5, 0.5)
    float dist = distance(UV, vec2(0.5));

    // Soft radial glow falloff
    float glow = 1.0 - smoothstep(0.2, 0.7, dist);

    // Pulse animation
    float pulse = sin(TIME * pulse_speed) * 0.5 + 0.5;

    vec3 final_color = tex.rgb + glow * pulse * glow_strength * glow_color.rgb;

    COLOR = vec4(final_color, tex.a);
}