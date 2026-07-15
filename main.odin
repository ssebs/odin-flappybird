package main

import "core:fmt"
import rl "vendor:raylib"

create_window :: proc() {
	rl.InitWindow(i32(WINDOW_SIZE_X), i32(WINDOW_SIZE_Y), GAME_NAME_C)
	rl.SetTargetFPS(60)
}

update_game :: proc() {

}

draw_game :: proc() {
	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.ClearBackground(rl.GRAY)

}


main :: proc() {
	fmt.println("Hello, world!")
    create_window()
    defer rl.CloseWindow()
    for !rl.WindowShouldClose(){
        update_game()
        draw_game()
    }
}
