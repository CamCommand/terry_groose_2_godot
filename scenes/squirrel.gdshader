shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform float glow_size = 10.0;
uniform float glow_strength = 0.0;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    
    float alpha = tex.a;
    
    // Sample surrounding pixels for glow
    float glow = 0.0;
    for (int x = -8; x <= 8; x++) {
        for (int y = -8; y <= 8; y++) {
            vec2 offset = vec2(float(x), float(y)) * glow_size * TEXTURE_PIXEL_SIZE;
            glow += texture(TEXTURE, UV + offset).a;
        }
    }
    
    glow = glow / 50.0; // average samples
    
    vec4 aura = glow_color * glow * glow_strength;
    
    COLOR = tex + aura * (1.0 - alpha);
}