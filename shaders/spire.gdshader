shader_type canvas_item;
render_mode unshaded;

uniform float shadow_speed = 0.5;
uniform float shadow_darkness = 0.3;
uniform float shadow_band_width = 0.5;
uniform float shadow_edge_softness = 0.1;
uniform float shadow_extra_padding = 0.3;

uniform vec2 shadow_origin = vec2(0.5, 0.5); // Position on the screen to sync with planet's center
uniform float shadow_scale = 1.0; // Match planet's scale

void fragment() {
    // Convert UV to screen-centered space relative to the shadow_origin
    vec2 centered_uv = (SCREEN_UV - shadow_origin) * shadow_scale * 2.0;

    float half_band = shadow_band_width * 0.5;
    float total_distance = 2.0 + shadow_band_width + shadow_extra_padding;

    float shadow_center = mod(TIME * shadow_speed, total_distance) - 1.0 - half_band;
    float horizontal_dist = centered_uv.x - shadow_center;

    float left_edge = smoothstep(-half_band - shadow_edge_softness, -half_band, horizontal_dist);
    float right_edge = smoothstep(half_band, half_band + shadow_edge_softness, horizontal_dist);
    float shadow_band = left_edge * (1.0 - right_edge);

    float shadow_factor = mix(1.0, shadow_darkness, shadow_band);

    vec4 tex_color = texture(TEXTURE, UV);
    COLOR = vec4(tex_color.rgb * shadow_factor, tex_color.a);
}
