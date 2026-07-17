package game

import "core:math/rand"
import rl "vendor:raylib"

PipeSpawner :: struct #all_or_none {
	using game_object: GameObject,
	pipes:             [PIPE_PAIRS * 2]^Pipe,
	ground_height:     f32,
	reset_proc:        proc(this: ^PipeSpawner),
}

NewPipeSpawner :: proc(_ground_height: i32) -> ^PipeSpawner {
	ps: ^PipeSpawner = &PipeSpawner {
		game_object = GameObject {
			exit_proc = exit_pipespawner,
			update_proc = update_pipespawner,
			draw_proc = draw_pipespawner,
		},
		reset_proc = reset_pipespawner,
		pipes = [PIPE_PAIRS * 2]^Pipe{NewPipe(), NewPipe(), NewPipe(), NewPipe()},
		ground_height = f32(_ground_height),
	}
	ps->reset_proc()

	return ps
}
exit_pipespawner :: proc(this: ^PipeSpawner) {
	for pipe in this.pipes {
		pipe->exit_proc()
		free(pipe)
	}
}


update_pipespawner :: proc(this: ^PipeSpawner) {
	if game_state == GameState.DYING {
		return
	}
	scroll_pipes(this)

	for pipe in this.pipes {
		pipe->update_proc()
	}
}
draw_pipespawner :: proc(this: ^PipeSpawner) {
	for pipe in this.pipes {
		pipe->draw_proc()
	}
}

reset_pipespawner :: proc(this: ^PipeSpawner) {
	// stagger the pairs evenly over the distance a pair travels before it wraps
	spacing := (WINDOW_SIZE_X + f32(this.pipes[0].texture.width)) / PIPE_PAIRS
	for pair in 0 ..< PIPE_PAIRS {
		top, bottom := this.pipes[pair * 2], this.pipes[pair * 2 + 1]
		top.upside_down = true
		place_pipe_pair(this, top, bottom, WINDOW_SIZE_X + f32(pair) * spacing)
	}
}
/*
* Put a pair at x with a fresh gap, kept fully on screen and above the ground
*/
@(private = "file")
place_pipe_pair :: proc(this: ^PipeSpawner, top, bottom: ^Pipe, x: f32) {
	gap_center := rand.float32_range(PIPE_GAP, WINDOW_SIZE_Y - this.ground_height - PIPE_GAP)
	top.position = {x, gap_center - PIPE_GAP / 2 - f32(top.texture.height)}
	bottom.position = {x, gap_center + PIPE_GAP / 2}
	top.scored = false
	bottom.scored = false
}

/*
* Scroll each pair left, recycling it off the right edge once fully off screen
*/
@(private = "file")
scroll_pipes :: proc(this: ^PipeSpawner) {
	dx := GROUND_MOVE_SPEED * rl.GetFrameTime()

	for pair in 0 ..< PIPE_PAIRS {
		top, bottom := this.pipes[pair * 2], this.pipes[pair * 2 + 1]
		top.position.x -= dx
		bottom.position.x -= dx

		if top.position.x <= -f32(top.texture.width) {
			place_pipe_pair(this, top, bottom, WINDOW_SIZE_X)
		}
	}
}

////////////////////////////////////////////////////////////////////////////////


// Single Pipe
Pipe :: struct #all_or_none {
	using game_entity: GameEntity,
	texture:           rl.Texture,
	upside_down:       bool,
	scored:            bool,
}

NewPipe :: proc() -> ^Pipe {
	tx := rl.LoadTexture(texture_file_name_map[TextureName.PIPE])

	p: ^Pipe = new_clone(
		Pipe {
			game_entity = GameEntity {
				game_object = GameObject {
					update_proc = update_pipe,
					draw_proc = draw_pipe,
					exit_proc = exit_pipe,
				},
				position = 0,
				rotation = 0,
				velocity = 0,
			},
			texture = tx,
			upside_down = false,
			scored = false,
		},
	)
	return p
}

exit_pipe :: proc(this: ^Pipe) {
	rl.UnloadTexture(this.texture)
}

draw_pipe :: proc(this: ^Pipe) {
	src := rl.Rectangle{0, 0, f32(this.texture.width), f32(this.texture.height)}
	if this.upside_down {
		// negative height flips the sprite, keeping position as its top-left corner
		src.height = -src.height
	}
	rl.DrawTextureRec(this.texture, src, this.position, rl.WHITE)
}
update_pipe :: proc(this: ^Pipe) {

}
