package game

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

Background :: struct #all_or_none {
	texture:     rl.Texture,
	draw_proc:   proc(this: ^Background),
	update_proc: proc(this: ^Background),
}

init_background :: proc(img_path: string) -> ^Background {
	cs, err := strings.clone_to_cstring(img_path)
	if err != nil {
		fmt.println("Could not convert string to cstring: ", img_path)
	}
	tx := rl.LoadTexture(cs)

	b: ^Background = &Background {
		texture = tx,
		draw_proc = draw_background,
		update_proc = update_background,
	}
	return b
}

draw_background :: proc(this: ^Background) {
	rl.DrawTexture(this.texture, 0, 0, rl.WHITE)
}
update_background :: proc(this: ^Background) {}
