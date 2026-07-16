package game

import rl "vendor:raylib"

bg_pos: f32 = 0

Background :: struct #all_or_none {
	using game_object: GameObject,
	bg_texture:        rl.Texture,
}

init_background :: proc() -> ^Background {
	bg_tx := rl.LoadTexture(texture_file_name_map[TextureName.BG_DAY])

	b: ^Background = &Background {
		game_object = GameObject {
			draw_proc = draw_background,
			update_proc = update_background,
			exit_proc = exit_background,
		},
		bg_texture = bg_tx,
	}
	return b
}
exit_background :: proc(this: ^Background) {
	rl.UnloadTexture(this.bg_texture)
}

draw_background :: proc(this: ^Background) {
	rl.DrawTexture(this.bg_texture, i32(bg_pos), 0, rl.WHITE)
	rl.DrawTexture(this.bg_texture, i32(i32(WINDOW_SIZE_X + bg_pos)), 0, rl.WHITE)
}

update_background :: proc(this: ^Background) {
	if game_state == GameState.PLAYING {
		parallax_it(&bg_pos, f32(this.bg_texture.width), GROUND_MOVE_SPEED / 2)
	} else {
		bg_pos = 0
	}
}
