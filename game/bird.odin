// Bird.odin - The player
package game

import rl "vendor:raylib"


@(private = "file")
starting_pos: rl.Vector2
@(private = "file")
was_just_reset := true

Bird :: struct #all_or_none {
	using game_entity: GameEntity,
	textures:          [BirdFrame]rl.Texture,
	size:              rl.Vector2, // every frame is the same size
	flap_frame:        int, // index into BIRD_FLAP_SEQ, or -1 when resting
	flap_timer:        f32,
	flap_sound:        rl.Sound,
	reset_proc:        proc(this: ^Bird),
	is_falling:        bool,
}

NewBird :: proc() -> ^Bird {
	txs: [BirdFrame]rl.Texture
	for name, frame in bird_frame_texture_map {
		txs[frame] = load_texture(name)
	}

	size := rl.Vector2{f32(txs[BirdFrame.MID].width), f32(txs[BirdFrame.MID].height)}
	starting_pos = rl.Vector2{(WINDOW_SIZE_X / 2) - size.x / 2, WINDOW_SIZE_Y / 2}

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
		textures = txs,
		size = size,
		flap_frame = -1,
		flap_timer = 0,
		flap_sound = load_sound(SoundName.WING),
		reset_proc = reset_bird,
		is_falling = false,
	}

	return b
}
@(private = "file")
exit_bird :: proc(this: ^Bird) {
	rl.UnloadSound(this.flap_sound)
	for tx in this.textures {
		rl.UnloadTexture(tx)
	}
}
@(private = "file")
draw_bird :: proc(this: ^Bird) {
	frame := BirdFrame.MID
	if this.flap_frame >= 0 {
		seq := BIRD_FLAP_SEQ
		frame = seq[this.flap_frame]
	}

	// position is the top-left corner, but the tilt has to pivot on the center
	origin := this.size / 2
	rl.DrawTexturePro(
		this.textures[frame],
		rl.Rectangle{0, 0, this.size.x, this.size.y},
		rl.Rectangle{this.position.x + origin.x, this.position.y + origin.y, this.size.x, this.size.y},
		origin,
		this.rotation,
		rl.WHITE,
	)
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
		// restart the wingbeat, so tapping mid-beat still reads as a flap
		this.flap_frame = 0
		this.flap_timer = 0
		rl.PlaySound(this.flap_sound)
	}
	this.velocity += current_gravity()
	this.position.y -= this.velocity * rl.GetFrameTime()
	this.rotation = bird_rotation(this.velocity)
	update_flap(this)

	if was_just_reset {
		was_just_reset = false
	}
}

/*
* Tilt is a pure function of velocity, split at 0 so the apex sits level.
*/
@(private = "file")
bird_rotation :: proc(velocity: f32) -> f32 {
	if velocity >= 0 {
		return BIRD_ROT_UP * min(velocity / JUMP, 1)
	}
	return BIRD_ROT_DOWN * min(velocity / BIRD_ROT_VEL_DOWN, 1)
}

@(private = "file")
update_flap :: proc(this: ^Bird) {
	if this.flap_frame < 0 {
		return
	}

	this.flap_timer += rl.GetFrameTime()
	for this.flap_timer >= BIRD_FLAP_FRAME_TIME {
		this.flap_timer -= BIRD_FLAP_FRAME_TIME
		this.flap_frame += 1
		if this.flap_frame >= len(BIRD_FLAP_SEQ) {
			this.flap_frame = -1
			return
		}
	}
}
@(private = "file")
reset_bird :: proc(this: ^Bird) {
	this.position = starting_pos
	this.velocity = 0
	this.rotation = 0
	this.flap_frame = -1
	this.flap_timer = 0
	was_just_reset = true
}
