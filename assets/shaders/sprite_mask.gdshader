shader_type canvas_item;

uniform sampler2D mask_texture;
uniform ivec2 mask_offset = ivec2(0, 0);

void fragment() {
	ivec2 texture_size = textureSize(TEXTURE, 0);
	ivec2 mask_texture_size = textureSize(mask_texture, 0);
    vec4 color = texture(TEXTURE, UV);
	vec2 ratio = vec2(1, 1) / (vec2(mask_texture_size) / vec2(texture_size));
	vec2 coord = (UV + vec2(mask_offset)) * ratio;
	vec4 mask = texelFetch(mask_texture, ivec2(coord * vec2(mask_texture_size)), 0);

    COLOR.a *= mask.a;
}