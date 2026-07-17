package game

import rl "vendor:raylib"

HUD :: struct #all_or_none {
	using game_object: GameObject,
	gameover_texture:  rl.Texture,
	pregame_texture:   rl.Texture,
	font:              rl.Font,
	score:             int,
}

NewHUD :: proc() -> ^HUD {
	gameover_tx := rl.LoadTexture(texture_file_name_map[TextureName.BG_DAY])
	pregame_tx := rl.LoadTexture(texture_file_name_map[TextureName.BG_DAY])
	f := rl.LoadFontEx(FONT_FILENAME, 32, nil, 0)

	h: ^HUD = &HUD {
		game_object = GameObject {
			update_proc = update_hud,
			draw_proc = draw_hud,
			exit_proc = exit_hud,
		},
		font = f,
		gameover_texture = gameover_tx,
		pregame_texture = pregame_tx,
		score = 0,
	}
	return h
}
@(private = "file")
exit_hud :: proc(this: ^HUD) {
	rl.UnloadTexture(this.gameover_texture)
	rl.UnloadTexture(this.pregame_texture)
	rl.UnloadFont(this.font)
}
@(private = "file")
draw_hud :: proc(this: ^HUD) {
	rl.DrawTextEx(this.font, "0 1 2 3 4", rl.Vector2{f32(WINDOW_SIZE_X) / 4, 20}, 32, 0, rl.WHITE)
}
@(private = "file")
update_hud :: proc(this: ^HUD) {}
