package game

import b2 "vendor:box2d"
import rl "vendor:raylib"

PipeSpawner :: struct #all_or_none {
	using game_object: GameObject,
	pipes:             [4]^Pipe,
}

NewPipeSpawner :: proc() -> ^PipeSpawner {
	ps: ^PipeSpawner = &PipeSpawner {
		game_object = GameObject {
			exit_proc = exit_pipespawner,
			update_proc = update_pipespawner,
			draw_proc = draw_pipespawner,
		},
		pipes = [4]^Pipe{NewPipe(false), NewPipe(true), NewPipe(false), NewPipe(true)},
	}
	return ps
}
exit_pipespawner :: proc(this: ^PipeSpawner) {
	for pipe in this.pipes {
		pipe->exit_proc()
		free(this.pipes[0])
	}
}
update_pipespawner :: proc(this: ^PipeSpawner) {

	this.pipes[0].position = {0, 0}
	this.pipes[1].position = {0, WINDOW_SIZE_Y - f32(this.pipes[1].texture.height)}


	for pipe in this.pipes {
		pipe->update_proc()
	}
}
draw_pipespawner :: proc(this: ^PipeSpawner) {
	for pipe in this.pipes {
		pipe->draw_proc()
	}
}

////////////////////////////////////////////////////////////////////////////////

// Single Pipe
Pipe :: struct #all_or_none {
	using game_entity: GameEntity,
	texture:           rl.Texture,
	upside_down:       bool,
}

NewPipe :: proc(is_upside_down: bool) -> ^Pipe {
	tx := rl.LoadTexture(texture_file_name_map[TextureName.PIPE])
	col := b2.MakeBox(f32(tx.width) / 2, f32(tx.height) / 2)

	p: ^Pipe = new_clone(
		Pipe {
			game_entity = GameEntity {
				game_object = GameObject {
					update_proc = update_pipe,
					draw_proc = draw_pipe,
					exit_proc = exit_pipe,
				},
				position = starting_pos,
				rotation = 0,
				velocity = 0,
				collision_shape = col,
			},
			texture = tx,
			upside_down = is_upside_down,
		},
	)
	return p
}

exit_pipe :: proc(this: ^Pipe) {
	rl.UnloadTexture(this.texture)
}

draw_pipe :: proc(this: ^Pipe) {
	rl.DrawTextureEx(this.texture, this.position, this.upside_down ? 0 : 180, 1.0, rl.WHITE)
}
update_pipe :: proc(this: ^Pipe) {

}
