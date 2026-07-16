// Bird.odin - The player
package game

import b2 "vendor:box2d"
import rl "vendor:raylib"

GRAVITY: f32 : -9.8
JUMP: f32 : 300.0

@(private = "file")
starting_pos: rl.Vector2
@(private = "file")
ground_height: i32
@(private = "file")
was_just_reset := true

Bird :: struct #all_or_none {
	using game_entity: GameEntity,
	texture:           rl.Texture,
	flap_sound:        rl.Sound,
	smack_sound:       rl.Sound,
}

NewBird :: proc(_ground_height: i32) -> ^Bird {
	ground_height = _ground_height

	tx := rl.LoadTexture(texture_file_name_map[TextureName.BIRD_DOWNFLAP])
	col := b2.MakeBox(f32(tx.width) / 2, f32(tx.height) / 2)
	starting_pos = rl.Vector2{(WINDOW_SIZE_X / 2) - f32(tx.width) / 2, WINDOW_SIZE_Y / 2}

	b: ^Bird = &Bird {
		game_entity = GameEntity {
			game_object = GameObject {
				update_proc = update_bird,
				draw_proc = draw_bird,
				exit_proc = exit_bird,
			},
			position = starting_pos,
			rotation = 0,
			velocity = 0,
			collision_shape = col,
		},
		texture = tx,
		flap_sound = rl.LoadSound(sound_file_name_map[SoundName.WING]),
		smack_sound = rl.LoadSound(sound_file_name_map[SoundName.HIT]),
	}

	return b
}
exit_bird :: proc(this: ^Bird) {
	rl.UnloadSound(this.flap_sound)
	rl.UnloadSound(this.smack_sound)
	rl.UnloadTexture(this.texture)
}


draw_bird :: proc(this: ^Bird) {
	// TODO: animate w/ sprite sheet
	rl.DrawTextureEx(this.texture, this.position, this.rotation, 1.0, rl.WHITE)
}

update_bird :: proc(this: ^Bird) {
	// Reset if we hit the bottom
	if this.position.y >= WINDOW_SIZE_Y - f32(ground_height + this.texture.height) {
		rl.PlaySound(this.smack_sound)
		reset_bird(this)
		game_state = GameState.STOPPED
		return
	}

	if game_state != GameState.PLAYING {
		return
	}

	// if player has input, apply -gravity
	if rl.IsKeyPressed(rl.KeyboardKey.SPACE) || was_just_reset {
		this.velocity = JUMP
		rl.PlaySound(this.flap_sound)
	}
	this.velocity += GRAVITY
	this.position.y -= this.velocity * rl.GetFrameTime()

	if was_just_reset {
		was_just_reset = false
	}
}

@(private = "file")
reset_bird :: proc(this: ^Bird) {
	this.position = starting_pos
	this.velocity = 0
	was_just_reset = true
}
