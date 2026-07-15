package game

import "core:fmt"
import rl "vendor:raylib"

score := 0
game_state: GameState = GameState.STOPPED
player_bird: Bird


init_game :: proc() {
	// init bird, add to game_objects
	player_bird = init_bird(texture_file_name_map[TextureName.BIRD_DOWNFLAP])^

	fmt.println("player_bird: ", player_bird)
	// ...
}

/*
* Mutate state here
*/
update_game :: proc() {
	player_bird->update_proc()
}

/*
* Draw from state here
*/
draw_game :: proc() {
	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.ClearBackground(rl.GRAY)

	player_bird->draw_proc()
}

GameState :: enum {
	STOPPED,
	STARTED,
	PAUSED,
}
