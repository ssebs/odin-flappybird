package game

import rl "vendor:raylib"

@(private = "file")
MAX_DIGITS :: 8

/*
* Renders a number from the digit sprites in ./assets/sprites/
*/
ScoreDisplay :: struct {
	digit_textures: [10]rl.Texture,
}

init_score_display :: proc() -> ScoreDisplay {
	s: ScoreDisplay
	for i in 0 ..< 10 {
		s.digit_textures[i] = rl.LoadTexture(
			texture_file_name_map[TextureName(int(TextureName.DIGIT_0) + i)],
		)
	}
	return s
}
exit_score_display :: proc(this: ^ScoreDisplay) {
	for tx in this.digit_textures {
		rl.UnloadTexture(tx)
	}
}
/*
* Draws score horizontally centered, top edge at top_y.
* Digit sprites are not uniform width (1.png is 16px, the rest 24px),
* so widths are summed rather than assumed.
*/
draw_score :: proc(this: ^ScoreDisplay, score: int, top_y: i32) {
	digits: [MAX_DIGITS]int
	count := 0

	// least-significant digit first, loops at least once so 0 draws as "0"
	n := max(score, 0)
	for {
		digits[count] = n % 10
		count += 1
		n /= 10
		if n == 0 || count >= MAX_DIGITS {
			break
		}
	}

	total_width := f32(count - 1) * SCORE_DIGIT_SPACING
	for i in 0 ..< count {
		total_width += f32(this.digit_textures[digits[i]].width)
	}

	x := (WINDOW_SIZE_X - total_width) / 2
	for i := count - 1; i >= 0; i -= 1 {
		tx := this.digit_textures[digits[i]]
		rl.DrawTexture(tx, i32(x), top_y, rl.WHITE)
		x += f32(tx.width) + SCORE_DIGIT_SPACING
	}
}
