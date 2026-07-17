package game

import "base:runtime"
import "core:fmt"
import "core:os"
import "core:path/filepath"
import rl "vendor:raylib"

GameObject :: struct #all_or_none {
	draw_proc:   proc(this: ^GameObject),
	update_proc: proc(this: ^GameObject),
	exit_proc:   proc(this: ^GameObject),
}

GameEntity :: struct #all_or_none {
	using game_object: GameObject,
	position:          rl.Vector2,
	rotation:          f32, // degrees
	velocity:          f32,
}

/*
* Handle moving a position var & reseting after 1 loop
*/
parallax_it :: proc(pos_var: ^f32, width: f32, move_speed: f32) {
	pos_var^ -= move_speed * rl.GetFrameTime()
	if abs(pos_var^) > width {
		pos_var^ = 0
	}
}


load_savegame :: proc() {
	runtime.DEFAULT_TEMP_ALLOCATOR_TEMP_GUARD()

	fp := get_savegame_fullpath()
	if fp == "" {
		return
	}

	if !os.exists(fp) {
		save_savegame()
	}

	save_txt, err := os.read_entire_file_from_path(fp, context.temp_allocator)
	if err != nil {
		fmt.eprintln("failed to load game. e:", err)
		return
	}

	fmt.println("loaded save:", string(save_txt))
}

save_savegame :: proc() {
	runtime.DEFAULT_TEMP_ALLOCATOR_TEMP_GUARD()

	fp := get_savegame_fullpath()
	if fp == "" {
		return
	}

	default_save := "SCORE=0\nVOL=0.8"
	if err := os.write_entire_file(fp, default_save); err != nil {
		fmt.eprintln("failed to save game. e:", err)
		return
	}

	fmt.println("saved save:", fp)
}


/*
* Returns the save file path allocated in the temp allocator.
* The caller owns it, so guard/free the temp allocator in the calling scope.
*/
@(private = "file")
get_savegame_fullpath :: proc() -> string {
	usr_dir, dir_err := os.user_data_dir(context.temp_allocator)
	if dir_err != nil {
		fmt.eprintln("failed to get user data dir. e:", dir_err)
		return ""
	}

	fp, join_err := filepath.join({usr_dir, SAVE_GAME_NAME}, context.temp_allocator)
	if join_err != nil {
		fmt.eprintln("failed to join filepath. e:", join_err)
		return ""
	}

	return fp
}
