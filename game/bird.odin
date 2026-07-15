// Bird.odin - The player
package game

import "core:fmt"
import "core:strings"
import b2 "vendor:box2d"
import rl "vendor:raylib"

gravity: f32 = -9.8
jump: f32 = 256.0


Bird :: struct #all_or_none {
	texture:         rl.Texture,
	position:        rl.Vector2,
	rotation:        f32, // degrees
	collision_shape: b2.Polygon,
	velocity:        f32,
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
	pos := rl.Vector2{(WINDOW_SIZE_X / 2) - f32(tx.width) / 2, WINDOW_SIZE_Y / 2}

	b: ^Bird = &Bird {
		texture = tx,
		position = pos,
		rotation = 0,
		velocity = 0,
		collision_shape = col,
		update_proc = update_bird,
		draw_proc = draw_bird,
	}

	return b
}

draw_bird :: proc(this: ^Bird) {
	// TODO: animate w/ sprite sheet
	rl.DrawTextureEx(this.texture, this.position, this.rotation, 1.0, rl.WHITE)
}

update_bird :: proc(this: ^Bird) {
	// Reset if we hit the bottom
	if this.position.y >= WINDOW_SIZE_Y {
		fmt.println("LOSE. Speed: ", this.velocity)
		this.position.y = 0
		this.velocity = 0
		return
	}


	// if player has input, apply -gravity
	if rl.IsKeyPressed(rl.KeyboardKey.SPACE) {
		this.velocity = jump
	}
	this.velocity += gravity

	this.position.y -= this.velocity * rl.GetFrameTime()
}
