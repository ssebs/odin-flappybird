package main

import "core:fmt"
import "core:strings"
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


	// Set Icon
	img_path := game.texture_file_name_map[game.TextureName.ICON]
	cs, err := strings.clone_to_cstring(img_path)
	if err != nil {
		fmt.println("Could not convert string to cstring: ", img_path)
	}
	icon_img := rl.LoadImage(cs)
	rl.SetWindowIcon(icon_img)
}
