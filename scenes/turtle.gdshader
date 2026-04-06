shader_type canvas_item;

uniform float glow_strength : hint_range(0.0, 2.0) = 0.6;
uniform float pulse_speed : hint_range(0.0, 10.0) = 2.0;
uniform vec4 glow_color : source_color = vec4(0.518, 0.871, 0.506, 1.0);

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    float dist = distance(UV, vec2(0.5));
    float glow = 1.0 - smoothstep(0.2, 0.7, dist);
    float pulse = sin(TIME * pulse_speed) * 0.5 + 0.5;

    float g = clamp(glow * pulse * glow_strength, 0.0, 1.0);

    // blend toward glow color; factor also uses sprite transparency so halo appears around edges
    float blend_amount = g * (.8 - tex.a) * glow_color.a;
    vec3 mixed = mix(tex.rgb, glow_color.rgb, blend_amount);

    COLOR = vec4(mixed, tex.a);
}