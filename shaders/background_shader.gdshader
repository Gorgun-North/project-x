shader_type canvas_item;
render_mode unshaded;

void fragment() {
    float speed = 0.001;            // Slow pan for a space feel
    float zoom = 1.0;             // Slight zoom (almost 1.0)
    float vertical_shift = 0.01;   // Small vertical drift
    float vertical_speed = 0.2;    // Slow vertical movement

    // Base UV
    vec2 uv = UV;

    // Apply very light zoom (centered on screen)
    uv = (uv - vec2(0.5)) / zoom + vec2(0.5);

    // Scroll horizontally (infinitely)
    uv.x = fract(uv.x + TIME * speed);

    // Smooth, slow vertical drift using sine wave
    uv.y += sin(TIME * vertical_speed) * vertical_shift;

    // Sample texture
    COLOR = texture(TEXTURE, uv);
}
