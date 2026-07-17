package game

import rl "vendor:raylib"

HUD :: struct #all_or_none {
	using game_object: GameObject,
	gameover_texture:  rl.Texture,
	pregame_texture:   rl.Texture,
	score_display:     ScoreDisplay,
	score:             int,
}

NewHUD :: proc() -> ^HUD {
	gameover_tx := rl.LoadTexture(texture_file_name_map[TextureName.GAMEOVER])
	pregame_tx := rl.LoadTexture(texture_file_name_map[TextureName.PREGAME])

	h: ^HUD = &HUD {
		game_object = GameObject {
			update_proc = update_hud,
			draw_proc = draw_hud,
			exit_proc = exit_hud,
		},
		gameover_texture = gameover_tx,
		pregame_texture = pregame_tx,
		score_display = init_score_display(),
		score = 0,
	}
	return h
}
@(private = "file")
exit_hud :: proc(this: ^HUD) {
	rl.UnloadTexture(this.gameover_texture)
	rl.UnloadTexture(this.pregame_texture)
	exit_score_display(&this.score_display)
}
@(private = "file")
draw_hud :: proc(this: ^HUD) {
	if game_state == GameState.PLAYING {
		draw_score(&this.score_display, this.score, SCORE_TOP_Y)
	} else if game_state == GameState.DYING {
		mid_x := f32(WINDOW_SIZE_X) / 2 - f32(this.gameover_texture.width) / 2
		rl.DrawTextureEx(this.gameover_texture, rl.Vector2{mid_x, 80}, 0, 1.0, rl.WHITE)
	} else if game_state == GameState.STOPPED {
		mid_x := f32(WINDOW_SIZE_X) / 2 - f32(this.pregame_texture.width) / 2
		rl.DrawTextureEx(this.pregame_texture, {mid_x, 100}, 0, 1.0, rl.WHITE)
	}
}
@(private = "file")
update_hud :: proc(this: ^HUD) {}
