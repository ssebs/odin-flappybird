// Bird.odin - The player
package game

import rl "vendor:raylib"


@(private = "file")
starting_pos: rl.Vector2
@(private = "file")
was_just_reset := true

Bird :: struct #all_or_none {
	using game_entity: GameEntity,
	texture:           rl.Texture,
	flap_sound:        rl.Sound,
	reset_proc:        proc(this: ^Bird),
	is_falling:        bool,
}

NewBird :: proc() -> ^Bird {
	tx := rl.LoadTexture(texture_file_name_map[TextureName.BIRD_DOWNFLAP])
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
		},
		texture = tx,
		flap_sound = rl.LoadSound(sound_file_name_map[SoundName.WING]),
		reset_proc = reset_bird,
		is_falling = false,
	}

	return b
}
@(private = "file")
exit_bird :: proc(this: ^Bird) {
	rl.UnloadSound(this.flap_sound)
	rl.UnloadTexture(this.texture)
}
@(private = "file")
draw_bird :: proc(this: ^Bird) {
	// TODO: animate w/ sprite sheet
	rl.DrawTextureEx(this.texture, this.position, this.rotation, 1.0, rl.WHITE)
}
@(private = "file")
update_bird :: proc(this: ^Bird) {
	if game_state == GameState.STOPPED {
		return
	}


	// if player has input, apply -gravity
	if this.is_falling {

	} else if rl.IsKeyPressed(rl.KeyboardKey.SPACE) ||
	   rl.IsMouseButtonPressed(rl.MouseButton.LEFT) ||
	   was_just_reset {
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
