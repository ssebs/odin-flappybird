// Bird.odin - The player
package game

import "core:fmt"
import "core:strings"
import b2 "vendor:box2d"
import rl "vendor:raylib"

Bird :: struct #all_or_none {
	texture:         rl.Texture,
	position:        rl.Vector2,
	rotation:        f32, // degrees
	collision_shape: b2.Polygon,
	draw_proc:       proc(this: ^Bird),
	update_proc:     proc(this: ^Bird),
}

init_bird :: proc(img_path: string) -> ^Bird {
	cs, err := strings.clone_to_cstring(img_path)
	if err != nil {
		fmt.println("Could not convert string to cstring: ", img_path)
	}

	tx := rl.LoadTexture(cs)
	// fmt.println("tex:", tx)

	col := b2.MakeBox(f32(tx.width) / 2, f32(tx.height) / 2)
	pos := rl.Vector2{f32(WINDOW_SIZE_X) / 2, f32(WINDOW_SIZE_Y) / 2}

	b: ^Bird = &Bird {
		texture = tx,
		position = pos,
		rotation = 0,
		collision_shape = col,
		update_proc = update_bird,
		draw_proc = draw_bird,
	}

	return b
}

draw_bird :: proc(this: ^Bird) {
	src_rect := rl.Rectangle {
		this.position.x,
		this.position.y,
		f32(this.texture.width),
		f32(this.texture.height),
	}
	dst_rect := rl.Rectangle {
		this.position.x,
		this.position.y,
		f32(this.texture.width),
		f32(this.texture.height),
	}
	origin := rl.Vector2{this.position.x, this.position.y + (f32(this.texture.height) / 2)}

	rl.DrawTexturePro(this.texture, src_rect, dst_rect, origin, this.rotation, rl.WHITE)

}

update_bird :: proc(this: ^Bird) {

}
