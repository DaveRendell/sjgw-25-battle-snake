shader_type canvas_item;


void fragment(){
  vec2 offset_1 = UV - vec2(0.5, 0.5);
  vec2 new_uv_1 = vec2(abs(offset_1.x), abs(offset_1.y));
  vec2 offset_2 = new_uv_1 - vec2(0.5 * sin(0.1 * TIME), 0.5 * cos(0.1 * TIME + 0.6));
  vec2 new_uv_2 = vec2(abs(offset_2.x), abs(offset_2.y));
  COLOR = texture(TEXTURE, new_uv_2);  
}