package game

import "core:fmt"
import "core:math/rand"
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
		pipes = [4]^Pipe{NewPipe(), NewPipe(), NewPipe(), NewPipe()},
	}
	return ps
}
exit_pipespawner :: proc(this: ^PipeSpawner) {
	for pipe in this.pipes {
		pipe->exit_proc()
		free(this.pipes[0])
	}
}

rename_me :: proc(pipes: [4]^Pipe) {

	offset_range: f32 = 20.0

	for i := 0; i < len(pipes); i += 1 {

		pipes[i].position.x -= GROUND_MOVE_SPEED * 0.5 * rl.GetFrameTime()
		if pipes[i].position.x <= 0 {
			pipes[i].upside_down = (i % 2 == 0) ? true : false

			pipes[i].position.x = WINDOW_SIZE_X
			if i % 2 == 0 {
				pipes[i].position.y = (0 + rand.float32_range(-offset_range, offset_range))
			} else {
				pipes[i].position.y =
					(WINDOW_SIZE_Y + rand.float32_range(-offset_range, offset_range))

			}
			if i >= 2 {
				pipes[i].position.x += f32(pipes[i].texture.width) * 3
			}
		}
	}
}

update_pipespawner :: proc(this: ^PipeSpawner) {
	rename_me(this.pipes)

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

NewPipe :: proc() -> ^Pipe {
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
				position = 0,
				rotation = 0,
				velocity = 0,
				collision_shape = col,
			},
			texture = tx,
			upside_down = false,
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
