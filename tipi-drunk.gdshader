shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform float wave_speed : hint_range(0.0, 10.0) = 2.0;
uniform float wave_frequency : hint_range(0.0, 20.0) = 5.0;
uniform float wave_amplitude : hint_range(0.0, 0.05) = 0.015;
uniform float chromatic_aberration : hint_range(0.0, 0.05) = 0.008;

void fragment() {
    vec2 uv = SCREEN_UV;
    
    // Calculate sine waves for UV distortion
    float wave_x = sin(uv.y * wave_frequency + TIME * wave_speed) * wave_amplitude;
    float wave_y = cos(uv.x * wave_frequency + TIME * wave_speed * 0.8) * wave_amplitude;
    
    vec2 distorted_uv = uv + vec2(wave_x, wave_y);
    
    // Sample RGB channels separately for chromatic aberration
    float r = texture(screen_texture, distorted_uv + vec2(chromatic_aberration, 0.0)).r;
    float g = texture(screen_texture, distorted_uv).g;
    float b = texture(screen_texture, distorted_uv - vec2(chromatic_aberration, 0.0)).b;
    
    COLOR = vec4(r, g, b, 0.1);
}