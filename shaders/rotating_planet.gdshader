shader_type canvas_item;
render_mode unshaded;

uniform float scroll_speed = 0.1;
uniform vec4 atmosphere_color : source_color = vec4(0.4, 0.6, 1.0, 1.0);
uniform float atmosphere_thickness = 0.2;
uniform float pixel_steps = 8.0;

uniform float planet_radius = 0.85;
uniform float edge_pixelation = 64.0;

uniform float cloud_speed = 0.01;
uniform float cloud_scale = 4.0;
uniform float cloud_strength = 0.5;
uniform vec3 cloud_color = vec3(1.0);
uniform float cloud_threshold = 0.5;
uniform float cloud_edge_softness = 0.2;
uniform float cloud_pixel_size = 16.0;

uniform vec3 rim_glow_color = vec3(0.3, 0.4, 0.8);

uniform float shadow_speed = 0.5;         // Speed of shadow moving left->right
uniform float shadow_darkness = 0.3;      // How dark the shadow is
uniform float shadow_band_width = 0.5;    // Width of shadow band in UV space
uniform float shadow_edge_softness = 0.1;
uniform float shadow_extra_padding = 0.3; // Extra padding for shadow reset

uniform float planet_saturation = 1.0;    // Saturation control (0 = gray, 1 = original color)

// Simple smooth noise function (value noise)
float smooth_noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);

    float a = fract(sin(dot(i, vec2(12.9898, 78.233))) * 43758.5453);
    float b = fract(sin(dot(i + vec2(1.0, 0.0), vec2(12.9898, 78.233))) * 43758.5453);
    float c = fract(sin(dot(i + vec2(0.0, 1.0), vec2(12.9898, 78.233))) * 43758.5453);
    float d = fract(sin(dot(i + vec2(1.0, 1.0), vec2(12.9898, 78.233))) * 43758.5453);

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Saturation adjustment helper function
vec3 adjust_saturation(vec3 color, float saturation) {
    float gray = dot(color, vec3(0.299, 0.587, 0.114));
    return mix(vec3(gray), color, saturation);
}

void fragment() {
    vec2 centered_uv = UV * 2.0 - 1.0; // [-1,1] space
    float dist = length(centered_uv);
    float stepped_dist = floor(dist * edge_pixelation) / edge_pixelation;

    if (dist > planet_radius + atmosphere_thickness) {
        discard;
    }

    float half_band = shadow_band_width * 0.5;
    float total_distance = 2.0 + shadow_band_width + shadow_extra_padding;

    // shadow_center moves from (-1 - half_band) to (1 + half_band)
    float shadow_center = mod(TIME * shadow_speed, total_distance) - 1.0 - half_band;

    // Distance from this pixel to shadow center horizontally
    float horizontal_dist = centered_uv.x - shadow_center;

    // Compute smooth transition on left edge
    float left_edge = smoothstep(-half_band - shadow_edge_softness, -half_band, horizontal_dist);

    // Compute smooth transition on right edge
    float right_edge = smoothstep(half_band, half_band + shadow_edge_softness, horizontal_dist);

    // Combine edges to create shadow band
    float shadow_band = left_edge * (1.0 - right_edge);

    // Mix shadow darkness and lightness based on band presence
    float shadow_factor = mix(1.0, shadow_darkness, shadow_band);

    // Scroll texture horizontally
    vec2 uv = UV;
    uv.x = fract(uv.x - TIME * scroll_speed);
    vec4 tex_color = texture(TEXTURE, uv);

    if (stepped_dist <= planet_radius) {
        vec2 cloud_uv = UV * cloud_scale;
        cloud_uv = floor(cloud_uv * cloud_pixel_size) / cloud_pixel_size;
        cloud_uv.x += TIME * cloud_speed;

        float cloud_noise_val = smooth_noise(cloud_uv);
        float cloud_mask = smoothstep(cloud_threshold - cloud_edge_softness, cloud_threshold + cloud_edge_softness, cloud_noise_val);

        vec3 base_col = tex_color.rgb * shadow_factor;
        vec3 cloud_tinted = mix(base_col, cloud_color * shadow_factor, cloud_mask * cloud_strength);

        // Apply saturation here:
        cloud_tinted = adjust_saturation(cloud_tinted, planet_saturation);

        // --- Atmosphere blending on clouds ---
        float atmosphere_blend_start = planet_radius - 0.1;
        float atmosphere_blend_end = planet_radius + atmosphere_thickness;
        float atmosphere_blend_factor = smoothstep(atmosphere_blend_start, atmosphere_blend_end, dist);

        vec3 cloud_with_atmosphere = mix(cloud_tinted, atmosphere_color.rgb, atmosphere_blend_factor * 0.2);

        float vignette = smoothstep(planet_radius, planet_radius - 0.2, dist);
        cloud_with_atmosphere = mix(cloud_with_atmosphere, cloud_with_atmosphere * 0.5, vignette * 0.7);

        COLOR = vec4(cloud_with_atmosphere, tex_color.a);
    }
    else if (stepped_dist <= planet_radius + atmosphere_thickness) {
        float t = (stepped_dist - planet_radius) / atmosphere_thickness;
        float stepped = floor(t * pixel_steps) / pixel_steps;
        float alpha = 1.0 - stepped;

        float rim_factor = smoothstep(planet_radius + atmosphere_thickness, planet_radius + atmosphere_thickness * 0.3, dist);
        vec3 rim_color = rim_glow_color * rim_factor;

        vec3 atmosphere_tint = atmosphere_color.rgb + rim_color;

        // Apply saturation to atmosphere color
        atmosphere_tint = adjust_saturation(atmosphere_tint, planet_saturation);

        COLOR = vec4(atmosphere_tint, atmosphere_color.a * alpha * rim_factor);
    }
}
