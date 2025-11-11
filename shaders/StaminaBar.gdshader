shader_type canvas_item;

uniform float radius : hint_range(0, 20) = 8.0;

void fragment() {
	vec2 size = TEXTURE_PIXEL_SIZE * 1.0 / SCREEN_PIXEL_SIZE;
	vec2 uv = UV;
	
	// Máscara de redondeo
	vec2 corner = vec2(radius) / (size * 2.0);
	vec2 dist_to_corner = min(uv, 1.0 - uv);
	float rounded_alpha = smoothstep(0.0, 0.01, min(dist_to_corner.x, dist_to_corner.y) - corner.x);
	
	// Muestrear la textura original (Godot ya la pasa como TEXTURE)
	vec4 color = texture(TEXTURE, uv);
	
	// Aplicar máscara
	COLOR = vec4(color.rgb, color.a * rounded_alpha);
}