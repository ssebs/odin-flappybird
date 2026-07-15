package game

import rl "vendor:raylib"

ground_move_speed: f32 = 32.0
ground_pos: f32 = 0


Background :: struct #all_or_none {
	bg_texture:     rl.Texture,
	ground_texture: rl.Texture,
	draw_proc:      proc(this: ^Background),
	update_proc:    proc(this: ^Background),
}

init_background :: proc() -> ^Background {
	bg_tx := rl.LoadTexture(texture_file_name_map[TextureName.BG_DAY])
	ground_tx := rl.LoadTexture(texture_file_name_map[TextureName.BASE])

	b: ^Background = &Background {
		bg_texture = bg_tx,
		ground_texture = ground_tx,
		draw_proc = draw_background,
		update_proc = update_background,
	}
	return b
}

draw_background :: proc(this: ^Background) {
	rl.DrawTexture(this.bg_texture, 0, 0, rl.WHITE)

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
update_background :: proc(this: ^Background) {
	if game_state == GameState.PLAYING {
		ground_pos -= ground_move_speed * rl.GetFrameTime()
	} else {
		ground_pos = 0
	}
}

exit_background :: proc(this: ^Background) {
	rl.UnloadTexture(this.bg_texture)
	rl.UnloadTexture(this.ground_texture)
}
