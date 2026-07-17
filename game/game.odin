package game

import "core:fmt"
import rl "vendor:raylib"

game_state: GameState = GameState.STOPPED

player_bird: Bird
score: int
bg: Background
ground: Ground
pipe_spawner: PipeSpawner
smack_sound: rl.Sound
fall_sound: rl.Sound
whoosh_sound: rl.Sound
money_sound: rl.Sound

init_game :: proc() {
	bg = init_background()^
	ground = init_ground()^
	player_bird = NewBird()^
	pipe_spawner = NewPipeSpawner(ground.ground_texture.height)^

	money_sound = rl.LoadSound(sound_file_name_map[SoundName.POINT])
	whoosh_sound = rl.LoadSound(sound_file_name_map[SoundName.SWOOSH])
	fall_sound = rl.LoadSound(sound_file_name_map[SoundName.DIE])
	smack_sound = rl.LoadSound(sound_file_name_map[SoundName.HIT])
	rl.PlaySound(whoosh_sound)
}
exit_game :: proc() {
	rl.UnloadSound(whoosh_sound)
	rl.UnloadSound(money_sound)
	rl.UnloadSound(fall_sound)
	rl.UnloadSound(smack_sound)

	exit_bird(&player_bird)
	exit_background(&bg)
	exit_ground(&ground)
	exit_pipespawner(&pipe_spawner)
}

/*
* Mutate state here
*/
update_game :: proc() {
	if game_state == GameState.STOPPED {
		if rl.IsKeyPressed(rl.KeyboardKey.SPACE) || rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
			game_state = GameState.PLAYING
		}
	} else {
		bg->update_proc()
		pipe_spawner->update_proc()
		ground->update_proc()
		player_bird->update_proc()

		check_collisions()
	}
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
	for pipe in pipe_spawner.pipes {
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
			pipe.scored = true
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
	player_bird->reset_proc()
	pipe_spawner->reset_proc()
	game_state = GameState.STOPPED

}
@(private = "file")
player_score :: proc() {
	score += 1
	fmt.println("Scored! - ", score)
	rl.PlaySound(money_sound)
	// increase score UI
}

/*
* Scales the native-resolution content to fit the window, keeping aspect ratio
* with centered black letterbox bars. Clips overscan to the play area.
* NOTE - this func was written by claude.
*/
@(private = "file")
begin_scaled_view :: proc() {
	w, h := f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight())
	zoom := min(w / WINDOW_SIZE_X, h / WINDOW_SIZE_Y)
	offset := rl.Vector2{(w - WINDOW_SIZE_X * zoom) * 0.5, (h - WINDOW_SIZE_Y * zoom) * 0.5}

	rl.BeginScissorMode(
		i32(offset.x),
		i32(offset.y),
		i32(WINDOW_SIZE_X * zoom),
		i32(WINDOW_SIZE_Y * zoom),
	)
	rl.BeginMode2D(rl.Camera2D{zoom = zoom, offset = offset})
}
/*
* NOTE - this func was written by claude
*/
@(private = "file")
end_scaled_view :: proc() {
	rl.EndMode2D()
	rl.EndScissorMode()
}
