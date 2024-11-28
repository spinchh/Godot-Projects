shader_type canvas_item;

uniform bool flash_white = false;
uniform bool translucent = false;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	
	if (tex_color.a == 0.0){
		discard;
	}
	
	if (flash_white) {
		COLOR = vec4(1.0, 1.0, 1.0, tex_color.a);
	}
	else if (translucent) {
		COLOR = vec4(tex_color.rgb, .5);
	}
	else{
		COLOR = tex_color;
	}
}
