shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(0.703, 0.0, 0.207, 1.0);
uniform float glow_strength : hint_range(0.0, 5.0) = 1.5;
uniform float glow_spread : hint_range(0.0, 10.0) = 2.0;

void fragment() {
    vec4 base = texture(TEXTURE, UV);

    float alpha = base.a;

    // Sample surrounding pixels to create a blur/glow effect
    float glow = 0.0;
    for (int x = -2; x <= 2; x++) {
        for (int y = -2; y <= 2; y++) {
            vec2 offset = vec2(float(x), float(y)) * glow_spread / 100.0;
            glow += texture(TEXTURE, UV + offset).a;
        }
    }

    glow /= 25.0; // normalize blur samples

    vec4 glow_out = glow_color * glow * glow_strength;

    // Combine base text and glow
    COLOR = base + glow_out;
}
