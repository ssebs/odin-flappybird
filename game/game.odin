package game

import rl "vendor:raylib"

score := 0
game_state: GameState = GameState.STOPPED
player_bird: Bird
bg: Background

init_game :: proc() {
	bg = init_background()^

	player_bird = init_bird(bg.ground_texture.height)^
	// fmt.println("player_bird: ", player_bird)

	// ...
}

/*
* Mutate state here
*/
update_game :: proc() {
	bg->update_proc()
	player_bird->update_proc()
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

GameState :: enum {
	STOPPED,
	STARTED,
	PAUSED,
}
