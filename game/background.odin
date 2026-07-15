package game

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

Background :: struct #all_or_none {
	bg_texture:     rl.Texture,
	ground_texture: rl.Texture,
	draw_proc:      proc(this: ^Background),
	update_proc:    proc(this: ^Background),
}

init_background :: proc() -> ^Background {
	bg_tx := rl.LoadTexture(texture_file_name_map[TextureName.BG_DAY])
	ground_tx := rl.LoadTexture(texture_file_name_map[TextureName.BASE])

	b: ^Background = &Background {
		bg_texture = bg_tx,
		ground_texture = ground_tx,
		draw_proc = draw_background,
		update_proc = update_background,
	}
	return b
}

draw_background :: proc(this: ^Background) {
	rl.DrawTexture(this.bg_texture, 0, 0, rl.WHITE)

	rl.DrawTexture(
		this.ground_texture,
		0,
		i32(WINDOW_SIZE_Y) - this.ground_texture.height,
		rl.WHITE,
	)
}
update_background :: proc(this: ^Background) {}
