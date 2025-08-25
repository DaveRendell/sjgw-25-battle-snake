shader_type canvas_item;

uniform float animation_speed = 0.1;

void fragment(){
  vec2 offset_1 = UV - vec2(0.5, 0.5);
  vec2 new_uv_1 = vec2(abs(offset_1.x), abs(offset_1.y));
  vec2 offset_2 = new_uv_1 - vec2(0.5 * sin(animation_speed * TIME), 0.5 * cos(animation_speed * TIME + 0.6));
  vec2 new_uv_2 = vec2(abs(offset_2.x), abs(offset_2.y));
  COLOR = texture(TEXTURE, new_uv_2);
}