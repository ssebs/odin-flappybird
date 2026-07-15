package game

import rl "vendor:raylib"

score := 0
game_state: GameState = GameState.STOPPED
player_bird: Bird
bg: Background
whoosh_sound: rl.Sound

init_game :: proc() {
	bg = init_background()^

	player_bird = init_bird(bg.ground_texture.height)^
	// fmt.println("player_bird: ", player_bird)

	whoosh_sound = rl.LoadSound(sound_file_name_map[SoundName.SWOOSH])
	rl.PlaySound(whoosh_sound)
}

/*
* Mutate state here
*/
update_game :: proc() {
	if game_state == GameState.STOPPED {
		if rl.IsKeyPressed(rl.KeyboardKey.SPACE) {
			game_state = GameState.PLAYING
		}
	} else if game_state == GameState.PLAYING {
		bg->update_proc()
		player_bird->update_proc()
	}
}

/*
* Draw from state here
*/
draw_game :: proc() {
	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.ClearBackground(rl.BLACK)

	begin_scaled_view()
	defer end_scaled_view()

	bg->draw_proc()
	player_bird->draw_proc()
}

/*
* Scales the native-resolution content to fit the window, keeping aspect ratio
* with centered black letterbox bars. Clips overscan to the play area.
* NOTE - this func was written by claude.
*/
begin_scaled_view :: proc() {
	w, h := f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight())
	zoom := min(w / WINDOW_SIZE_X, h / WINDOW_SIZE_Y)
	offset := rl.Vector2{(w - WINDOW_SIZE_X * zoom) * 0.5, (h - WINDOW_SIZE_Y * zoom) * 0.5}

	rl.BeginScissorMode(
		i32(offset.x),
		i32(offset.y),
		i32(WINDOW_SIZE_X * zoom),
		i32(WINDOW_SIZE_Y * zoom),
	)
	rl.BeginMode2D(rl.Camera2D{zoom = zoom, offset = offset})
}
/*
* NOTE - this func was written by claude
*/
end_scaled_view :: proc() {
	rl.EndMode2D()
	rl.EndScissorMode()
}

exit_game :: proc() {
	rl.UnloadSound(whoosh_sound)
	exit_bird(&player_bird)
	exit_background(&bg)
}
