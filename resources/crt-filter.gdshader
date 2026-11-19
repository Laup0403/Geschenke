shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// CRT & Aberration
uniform float curvature : hint_range(0.0, 10.0) = 4.0;
uniform float aberration_amount : hint_range(0.0, 0.05) = 0.003;

// Scanlines
uniform float line_count = 240.0;
uniform float scanline_opacity : hint_range(0.0, 1.0) = 0.2;

// Vignette
uniform float vignette_intensity = 0.4;
uniform float vignette_opacity : hint_range(0.0, 1.0) = 0.8;
uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    // 1. CRT Curve Distortion
    vec2 centered_uv = SCREEN_UV * 2.0 - 1.0;
    vec2 offset = centered_uv.yx / curvature;
    vec2 distorted_uv = centered_uv + centered_uv * offset * offset;
    distorted_uv = distorted_uv * 0.5 + 0.5;
    
    // 2. Chromatic Aberration
    vec2 aberration_dir = (distorted_uv - vec2(0.5)) * aberration_amount;
    float r = texture(screen_texture, distorted_uv - aberration_dir).r;
    float g = texture(screen_texture, distorted_uv).g;
    float b = texture(screen_texture, distorted_uv + aberration_dir).b;
    vec4 base_color = vec4(r, g, b, 1.0);
    
    // 3. Scanlines (Using TAU)
    float scanline = sin(distorted_uv.y * line_count * TAU);
    base_color.rgb = max(base_color.rgb - (clamp(scanline, 0.0, 1.0) * scanline_opacity), 0.0);
    
    // 4. Vignette
    float d = distance(distorted_uv, vec2(0.5, 0.5));
    float vignette = smoothstep(0.5 - vignette_intensity, 0.5 + vignette_intensity, d);
    base_color.rgb = mix(base_color.rgb, vignette_color.rgb, vignette * vignette_opacity);
    
    // 5. Bounds Check (Branchless)
    // Multiplies out to 0.0 if any UV coordinate is outside 0.0 to 1.0
    vec2 bounds = step(vec2(0.0), distorted_uv) * step(distorted_uv, vec2(1.0));
    float in_bounds = bounds.x * bounds.y;
    
    // 6. Final Output
    COLOR.rgb = base_color.rgb * in_bounds;
    COLOR.a = 1.0;
}
