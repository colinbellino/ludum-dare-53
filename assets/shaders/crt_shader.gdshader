shader_type canvas_item;

uniform vec2 screen_size = vec2(960, 540);
uniform vec2 bleed_size = vec2(3, 3);
uniform vec4 scanline_color : source_color;
uniform float scanline_size = 1.0;
uniform float distortion = 0.035;
uniform float distortion_tweak = 0.0;
uniform float bleed = 0.1;

uniform sampler2D screen : hint_screen_texture, filter_linear_mipmap;

// From https://www.shadertoy.com/view/wtBXRz
vec2 brownConradyDistortion(in vec2 uv, in float k1, in float k2)
{
    uv = uv * 2.0 - 1.0;	// brown conrady takes [-1:1]
    float r2 = uv.x*uv.x + uv.y*uv.y;
    uv *= 1.0 + k1 * r2 + k2 * r2 * r2;
    uv = (uv * .5 + .5);	// restore -> [0:1]
    return uv;
}

void fragment()
{
	vec2 uv = UV;
	uv = brownConradyDistortion(uv, distortion, distortion_tweak);
	
	vec2 pixel_coordinate = uv*screen_size;
	
	vec4 bleeding_color = textureGrad(screen, uv, bleed_size/screen_size, bleed_size/screen_size);
	vec4 current_color = texture(screen, uv);
	
	vec4 c = current_color;
	// TODO: Figure out analytical scanline formula to avoid artifacts
	vec4 scanline = scanline_color * vec4(1.0, 1.0, 1.0, abs(mod(pixel_coordinate.y, 1.0)-0.5)*scanline_size);
	c = current_color + bleeding_color * bleed;
	c.rgb = mix(c.rgb, scanline.rgb, scanline.a);
	COLOR = c;
}
