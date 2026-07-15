package game

import rl "vendor:raylib"

score := 0
game_state: GameState = GameState.STOPPED
game_objects: []GameObject

init_game :: proc() {
	// init bird, add to game_objects

	// ...
}

/*
* Mutate state here
*/
update_game :: proc() {

}

/*
* Draw from state here
*/
draw_game :: proc() {
	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.ClearBackground(rl.GRAY)
}

GameState :: enum {
	STOPPED,
	STARTED,
	PAUSED,
}
