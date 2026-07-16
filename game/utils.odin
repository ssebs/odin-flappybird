package game

import b2 "vendor:box2d"
import rl "vendor:raylib"

GameObject :: struct #all_or_none {
	draw_proc:   proc(this: ^GameObject),
	update_proc: proc(this: ^GameObject),
	exit_proc:   proc(this: ^GameObject),
}

GameEntity :: struct #all_or_none {
	using game_object: GameObject,
	position:          rl.Vector2,
	rotation:          f32, // degrees
	collision_shape:   b2.Polygon,
	velocity:          f32,
}

/*
* Handle moving a position var & reseting after 1 loop
*/
parallax_it :: proc(pos_var: ^f32, width: f32, move_speed: f32) {
	pos_var^ -= move_speed * rl.GetFrameTime()
	if abs(pos_var^) > width {
		pos_var^ = 0
	}
}
