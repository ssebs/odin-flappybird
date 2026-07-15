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
	rl.ClearBackground(rl.GRAY)

	bg->draw_proc()
	player_bird->draw_proc()
}

exit_game :: proc() {
	rl.UnloadSound(whoosh_sound)
	exit_bird(&player_bird)
	exit_background(&bg)
}
