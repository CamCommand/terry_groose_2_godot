shader_type canvas_item;

uniform float amplitude = 45.0;   // how strong the wobble is
uniform float frequency = 36.0;   // how many waves along the sprite
uniform float speed = 4.0;       // how fast it wiggles

void vertex() {
    float time = TIME * speed;
    
    // Use UV.y so the wobble runs along the body vertically
    float wave = sin(UV.y * frequency + time) * amplitude;
    
    VERTEX.x += wave;
}