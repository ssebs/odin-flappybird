package game

import "core:fmt"
import rl "vendor:raylib"

score := 0
game_state: GameState = GameState.STOPPED

player_bird: Bird
bg: Background
ground: Ground
pipe_spawner: PipeSpawner
whoosh_sound: rl.Sound

init_game :: proc() {
	bg = init_background()^
	ground = init_ground()^
	player_bird = NewBird()^
	pipe_spawner = NewPipeSpawner(ground.ground_texture.height)^

	whoosh_sound = rl.LoadSound(sound_file_name_map[SoundName.SWOOSH])
	rl.PlaySound(whoosh_sound)
}
exit_game :: proc() {
	rl.UnloadSound(whoosh_sound)
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
	} else if game_state == GameState.PLAYING {
		bg->update_proc()
		pipe_spawner->update_proc()
		ground->update_proc()
		player_bird->update_proc()

		check_collisions()
		check_scoring()
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
		rl.PlaySound(player_bird.smack_sound)
		player_bird->reset_proc()

		// pipes->reset_proc()

		game_state = GameState.STOPPED
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
				fmt.println("COLLIDE")
				rl.PlaySound(player_bird.smack_sound)
				player_bird->reset_proc()

				// pipes->reset_proc()

				game_state = GameState.STOPPED
				return
			}

		}
	}
}

@(private = "file")
check_scoring :: proc() {
	// check if we passed a pipe (see check_collisions, but only do X once out of +width)


	// play coin sound
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
