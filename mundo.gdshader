shader_type canvas_item;

uniform vec4 lightning_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float size : hint_range(0.,1.) = 0.5;
uniform float width : hint_range(0.,1.) = 0.1;
uniform float speed = 2.0;
uniform float cycle = 12.0;
uniform float ratio = 1.0;
uniform float time_shift = 0.0;

float rand(float x){
	return fract(sin(x)*100000.0);
}

void fragment(){
	float bolt = abs(mod(UV.y * cycle + (rand(TIME) + time_shift) * speed * -1., 0.5)-0.25)-0.125;
	bolt *= 4. * width;

	bolt *= (0.5 - abs(UV.y - 0.5)) * 2.;

	// 🔥 dispersión lateral
	float offset = (rand(floor(UV.y * cycle) + TIME + time_shift) - 0.5) * 0.3;

	float wave = abs(UV.x - 0.5 + bolt + offset);
	wave = 1. - step(size * .5, wave);

	vec4 display = lightning_color * vec4(wave);

	COLOR = display;
}