package main

import "core:fmt"
import "game"
import rl "vendor:raylib"


main :: proc() {
	fmt.println("Odin Flappybird")
	create_window()
	defer rl.CloseWindow()

	game.init_game()

	for !rl.WindowShouldClose() {
		game.update_game()
		game.draw_game()
	}
}

create_window :: proc() {
	rl.InitWindow(i32(game.WINDOW_SIZE_X), i32(game.WINDOW_SIZE_Y), game.GAME_NAME_C)
	rl.SetTargetFPS(60)
}
