package main

import "core:fmt"
import "game"
import rl "vendor:raylib"


main :: proc() {
	fmt.println("Odin Flappybird")

	create_window()
	defer rl.CloseWindow()

	rl.InitAudioDevice()
	defer rl.CloseAudioDevice()

	game.init_game()

	for !rl.WindowShouldClose() {
		game.update_game()
		game.draw_game()
	}
	game.exit_game()
}

create_window :: proc() {
	rl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
	rl.InitWindow(i32(game.WINDOW_SIZE_X), i32(game.WINDOW_SIZE_Y), game.GAME_NAME_C)
	rl.SetTargetFPS(60)

	icon_img := rl.LoadImage(game.texture_file_name_map[game.TextureName.ICON])
	rl.SetWindowIcon(icon_img)
}
