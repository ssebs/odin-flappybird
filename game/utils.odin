package game

import "base:runtime"
import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:strconv"
import "core:strings"
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
* Steps the difficulty has ramped at the current score. Fractional at the top,
* where the clamp lands mid-step.
*/
@(private = "file")
difficulty_steps :: proc() -> f32 {
	steps := f32(hud.score / SPEED_STEP_SCORE)
	if hud.fast_toggle.enabled {
		steps = f32(hud.score / FAST_SPEED_STEP_SCORE) * FAST_SPEED_STEP_JUMP
	}

	max_steps := (MAX_MOVE_SPEED - GROUND_MOVE_SPEED) / SPEED_STEP_AMOUNT
	return min(steps, max_steps)
}

/*
* Scroll speed for the current score. The ground, bg and pipes all derive from
* this, so they stay in step with each other.
*/
current_move_speed :: proc() -> f32 {
	return GROUND_MOVE_SPEED + difficulty_steps() * SPEED_STEP_AMOUNT
}

current_gravity :: proc() -> f32 {
	return GRAVITY + difficulty_steps() * GRAVITY_STEP_AMOUNT
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


SaveData :: struct {
	score: int,
	vol:   f32,
}

/*
* Reads the save file. Any key that is missing or unparseable keeps its default,
* so a partial or hand-edited file still loads. A missing file is not an error.
*/
load_savegame :: proc() -> SaveData {
	runtime.DEFAULT_TEMP_ALLOCATOR_TEMP_GUARD()

	save := SaveData {
		vol = DEFAULT_VOL,
	}

	fp := get_savegame_fullpath()
	if fp == "" {
		return save
	}

	save_txt, err := os.read_entire_file_from_path(fp, context.temp_allocator)
	if err != nil {
		if err != .Not_Exist {
			fmt.eprintln("failed to load game. e:", err)
		}
		return save
	}

	txt := string(save_txt)
	for line in strings.split_lines_iterator(&txt) {
		key, _, val := strings.partition(strings.trim_space(line), "=")

		switch key {
		case SAVE_KEY_SCORE:
			if n, ok := strconv.parse_int(val); ok {
				save.score = n
			} else {
				fmt.eprintln("bad", SAVE_KEY_SCORE, "in save, keeping default:", val)
			}
		case SAVE_KEY_VOL:
			if v, ok := strconv.parse_f32(val); ok {
				save.vol = v
			} else {
				fmt.eprintln("bad", SAVE_KEY_VOL, "in save, keeping default:", val)
			}
		}
	}

	fmt.println("loaded save:", save)
	return save
}

save_savegame :: proc(score: int, vol: f32) {
	runtime.DEFAULT_TEMP_ALLOCATOR_TEMP_GUARD()

	fp := get_savegame_fullpath()
	if fp == "" {
		return
	}

	save_txt := fmt.tprintf("%s=%d\n%s=%.2f", SAVE_KEY_SCORE, score, SAVE_KEY_VOL, vol)
	if err := os.write_entire_file(fp, save_txt); err != nil {
		fmt.eprintln("failed to save game. e:", err)
		return
	}

	fmt.println("saved save:", save_txt)
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
