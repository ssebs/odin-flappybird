package game

import "core:fmt"
import rl "vendor:raylib"

game_state: GameState = GameState.STOPPED

player_bird: Bird
bg: Background
ground: Ground
pipe_spawner: PipeSpawner
hud: HUD

master_volume: f32 = DEFAULT_VOL

smack_sound: rl.Sound
fall_sound: rl.Sound
whoosh_sound: rl.Sound
money_sound: rl.Sound

init_game :: proc() {
	bg = init_background()^
	ground = init_ground()^
	player_bird = NewBird()^
	pipe_spawner = NewPipeSpawner(ground.ground_texture.height)^
	hud = NewHUD()^

	money_sound = rl.LoadSound(sound_file_name_map[SoundName.POINT])
	whoosh_sound = rl.LoadSound(sound_file_name_map[SoundName.SWOOSH])
	fall_sound = rl.LoadSound(sound_file_name_map[SoundName.DIE])
	smack_sound = rl.LoadSound(sound_file_name_map[SoundName.HIT])

	save := load_savegame()
	hud.high_score = save.score

	// a hand-edited VOL may sit between stops, so play back the snapped value
	hud.volume_slider = init_volume_slider(save.vol)
	stops := VOLUME_STOPS
	apply_master_volume(stops[hud.volume_slider.stop])

	rl.PlaySound(whoosh_sound)
}

@(private = "file")
apply_master_volume :: proc(vol: f32) {
	master_volume = vol
	rl.SetMasterVolume(master_volume)
}

/*
* Applies vol to the audio device and persists it.
*/
set_master_volume :: proc(vol: f32) {
	apply_master_volume(vol)
	save_savegame(hud.high_score, master_volume)
}
exit_game :: proc() {
	rl.UnloadSound(whoosh_sound)
	rl.UnloadSound(money_sound)
	rl.UnloadSound(fall_sound)
	rl.UnloadSound(smack_sound)

	player_bird->exit_proc()
	bg->exit_proc()
	pipe_spawner->exit_proc()
	ground->exit_proc()
	hud->exit_proc()
}

/*
* Mutate state here
*/
update_game :: proc() {
	if game_state == GameState.STOPPED {
		update_volume_slider(&hud.volume_slider)

		if update_play_button(&hud) || rl.IsKeyPressed(rl.KeyboardKey.SPACE) {
			game_state = GameState.PLAYING
		}
	} else {
		// the whole play area is clickable to flap
		rl.SetMouseCursor(rl.MouseCursor.POINTING_HAND)

		bg->update_proc()
		pipe_spawner->update_proc()
		ground->update_proc()
		player_bird->update_proc()

		check_collisions()
	}
	hud->update_proc()
}

/*
* Draw from state here
*/
draw_game :: proc() {
	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.ClearBackground(rl.BLACK)
	begin_scaled_view()
	defer end_scaled_view()


	bg->draw_proc()
	pipe_spawner->draw_proc()
	ground->draw_proc()
	player_bird->draw_proc()
	hud->draw_proc()
}


@(private = "file")
check_collisions :: proc() {
	// Reset if we hit the bottom
	if player_bird.position.y >=
	   WINDOW_SIZE_Y - f32(ground.ground_texture.height + player_bird.texture.height) {
		player_bird.is_falling = false
		player_die()
		return
	}

	if player_bird.is_falling {
		return
	}

	// player/bird coords
	b_left_x := player_bird.position.x
	b_right_x := player_bird.position.x + f32(player_bird.texture.width)
	b_top_y := player_bird.position.y
	b_bot_y := player_bird.position.y + f32(player_bird.texture.height)

	// Reset if we hit a pipe
	for pipe, i in pipe_spawner.pipes {
		// pipe coords
		p_left_x := pipe.position.x
		p_right_x := pipe.position.x + f32(pipe.texture.width)
		p_top_y := pipe.position.y
		p_bot_y := pipe.position.y + f32(pipe.texture.height)

		// In pipe horizontally
		if b_right_x >= p_left_x && b_left_x <= p_right_x {

			// In pipe vertically
			if b_top_y <= p_bot_y && b_bot_y >= p_top_y {
				player_bird.is_falling = true
				player_die()
				return
			}

		}

		// Check if we passed a pipe
		if p_right_x <= b_left_x && !pipe.scored {
			// pipes are stored as pairs (top at pair*2, bottom at pair*2+1) sharing
			// an x, so score this one's partner too or it scores again next frame
			partner := i + 1 if i % 2 == 0 else i - 1
			pipe_spawner.pipes[i].scored = true
			pipe_spawner.pipes[partner].scored = true
			player_score()
			return
		}
	}
}


@(private = "file")
/*
* is_falling will play the smack sound, then the fall sound
*/
player_die :: proc() {
	if game_state != GameState.DYING {
		rl.PlaySound(smack_sound)
	}
	if player_bird.is_falling {
		game_state = GameState.DYING
		rl.PlaySound(fall_sound)
		return
	}

	fmt.println("Die!")

	hud.score = 0
	player_bird->reset_proc()
	pipe_spawner->reset_proc()
	game_state = GameState.STOPPED
}
@(private = "file")
player_score :: proc() {
	hud.score += 1
	if hud.score > hud.high_score {
		hud.high_score = hud.score
		save_savegame(hud.high_score, master_volume)
	}
	fmt.println("Scored! - ", hud.score)
	rl.PlaySound(money_sound)

}

/*
* Scales the native-resolution content to fit the window, keeping aspect ratio
* with centered black letterbox bars. Clips overscan to the play area.
* NOTE - this func was written by claude.
*/
@(private = "file")
scaled_camera :: proc() -> rl.Camera2D {
	w, h := f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight())
	zoom := min(w / WINDOW_SIZE_X, h / WINDOW_SIZE_Y)
	offset := rl.Vector2{(w - WINDOW_SIZE_X * zoom) * 0.5, (h - WINDOW_SIZE_Y * zoom) * 0.5}
	return rl.Camera2D{zoom = zoom, offset = offset}
}

/*
* Mouse position in native game coords. Hit testing must use this rather than
* rl.GetMousePosition(), which is in unscaled window coords.
*/
get_mouse_native_pos :: proc() -> rl.Vector2 {
	return rl.GetScreenToWorld2D(rl.GetMousePosition(), scaled_camera())
}

@(private = "file")
begin_scaled_view :: proc() {
	cam := scaled_camera()

	rl.BeginScissorMode(
		i32(cam.offset.x),
		i32(cam.offset.y),
		i32(WINDOW_SIZE_X * cam.zoom),
		i32(WINDOW_SIZE_Y * cam.zoom),
	)
	rl.BeginMode2D(cam)
}
/*
* NOTE - this func was written by claude
*/
@(private = "file")
end_scaled_view :: proc() {
	rl.EndMode2D()
	rl.EndScissorMode()
}
