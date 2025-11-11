shader_type canvas_item;

void fragment() {
    vec2 uv = UV;
    vec2 center = vec2(0.5, 0.5);
    float radius = 0.5;
    float distance_from_center = distance(uv, center);

    if (distance_from_center > radius) {
        discard; // Hace transparente lo que esté fuera del círculo
    }

    COLOR = texture(TEXTURE, uv);
}
