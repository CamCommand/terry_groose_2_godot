shader_type canvas_item;

uniform vec4 glow_color = vec4(0.30, 0.18, 0.08, 1.0);
uniform float intensity : hint_range(0.0, 5.0) = 2.0;
uniform float speed : hint_range(0.0, 10.0) = 2.0;
uniform float beam_width : hint_range(0.0, 1.0) = 0.4;
uniform float top_fade : hint_range(0.0, 1.0) = 0.0;



void fragment() {
    vec2 uv = UV;
    vec4 tex = texture(TEXTURE, uv);

    // Only affect the top portion
    float top_mask = smoothstep(top_fade, 1.0, uv.y);

    // Vertical beam centered horizontally
    float beam = 1.0 - smoothstep(beam_width, beam_width + 0.1, abs(uv.x - 0.5));

    // Animated magical shimmer
    float shimmer = sin((uv.y * 20.0) - TIME * speed) * 0.5 + 0.5;

    // Combine beam + shimmer
    float energy = beam * shimmer * top_mask * intensity;

    vec3 final_color = tex.rgb + glow_color.rgb * energy;

    COLOR = vec4(final_color, tex.a);
}