shader_type canvas_item;

// The amplitude of the wave.
uniform vec2 cell_range = vec2(5.0, 1.0);

// The amplitude of the wave.
uniform float speed: hint_range(0.0, 5.0) = 1.0;

vec2 flipbook(vec2 uv, vec2 size, float progress){
	progress = floor(mod(progress, (size.x * size.y)));
	vec2 frame_size = vec2(1.0, 1.0) / vec2(size.x, size.y);

	float h = mod(progress, size.x);
	float v = floor(progress / size.x);
	
	vec2 hv = vec2(h, v);
	vec2 frame = (uv / size) + hv * frame_size;
	
	return frame;
}

void fragment()
{
	vec2 flip_uv = flipbook(UV, cell_range, TIME * 10.0 * speed);
	vec4 flip_texture = texture(TEXTURE, flip_uv);
	COLOR = flip_texture;
}