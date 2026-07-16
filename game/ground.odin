package game

import rl "vendor:raylib"

ground_pos: f32 = 0

Ground :: struct #all_or_none {
	using game_object: GameObject,
	ground_texture:    rl.Texture,
}

init_ground :: proc() -> ^Ground {
	ground_tx := rl.LoadTexture(texture_file_name_map[TextureName.BASE])

	g: ^Ground = &Ground {
		game_object = GameObject {
			draw_proc = draw_ground,
			update_proc = update_ground,
			exit_proc = exit_ground,
		},
		ground_texture = ground_tx,
	}
	return g
}
exit_ground :: proc(this: ^Ground) {
	rl.UnloadTexture(this.ground_texture)
}

draw_ground :: proc(this: ^Ground) {
	rl.DrawTexture(
		this.ground_texture,
		i32(ground_pos),
		i32(WINDOW_SIZE_Y) - this.ground_texture.height,
		rl.WHITE,
	)
	rl.DrawTexture(
		this.ground_texture,
		i32(WINDOW_SIZE_X + ground_pos),
		i32(WINDOW_SIZE_Y) - this.ground_texture.height,
		rl.WHITE,
	)
}

update_ground :: proc(this: ^Ground) {
	if game_state == GameState.PLAYING {
		parallax_it(&ground_pos, f32(this.ground_texture.width), GROUND_MOVE_SPEED)
	} else {
		ground_pos = 0
	}
}
