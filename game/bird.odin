// Bird.odin - The player
package game

import "core:fmt"
import b2 "vendor:box2d"
import rl "vendor:raylib"

gravity: f32 = -9.8
jump: f32 = 300.0
starting_pos: rl.Vector2
ground_height: i32
was_just_reset := true

Bird :: struct #all_or_none {
	texture:         rl.Texture,
	position:        rl.Vector2,
	rotation:        f32, // degrees
	collision_shape: b2.Polygon,
	velocity:        f32,
	flap_sound:      rl.Sound,
	draw_proc:       proc(this: ^Bird),
	update_proc:     proc(this: ^Bird),
}

init_bird :: proc(_ground_height: i32) -> ^Bird {
	ground_height = _ground_height

	tx := rl.LoadTexture(texture_file_name_map[TextureName.BIRD_DOWNFLAP])
	col := b2.MakeBox(f32(tx.width) / 2, f32(tx.height) / 2)
	starting_pos = rl.Vector2{(WINDOW_SIZE_X / 2) - f32(tx.width) / 2, WINDOW_SIZE_Y / 2}

	b: ^Bird = &Bird {
		texture = tx,
		position = starting_pos,
		rotation = 0,
		velocity = 0,
		flap_sound = rl.LoadSound(sound_file_name_map[SoundName.WING]),
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
	if this.position.y >= WINDOW_SIZE_Y - f32(ground_height + this.texture.height) {
		fmt.println("LOSE. Speed: ", this.velocity)
		reset_bird(this)
		game_state = GameState.STOPPED
		return
	}

	if game_state != GameState.PLAYING {
		return
	}

	// if player has input, apply -gravity
	if rl.IsKeyPressed(rl.KeyboardKey.SPACE) || was_just_reset {
		this.velocity = jump
		rl.PlaySound(this.flap_sound)
	}
	this.velocity += gravity
	this.position.y -= this.velocity * rl.GetFrameTime()

	if was_just_reset {
		was_just_reset = false
	}
}

reset_bird :: proc(this: ^Bird) {
	this.position = starting_pos
	this.velocity = 0
	was_just_reset = true
}

exit_bird :: proc(this: ^Bird) {
	rl.UnloadSound(this.flap_sound)
	rl.UnloadTexture(this.texture)
}
