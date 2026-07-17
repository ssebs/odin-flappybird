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
* Splits score into digits, least-significant first.
* Loops at least once so 0 renders as "0".
*/
@(private = "file")
score_digits :: proc(score: int) -> (digits: [MAX_DIGITS]int, count: int) {
	n := max(score, 0)
	for {
		digits[count] = n % 10
		count += 1
		n /= 10
		if n == 0 || count >= MAX_DIGITS {
			break
		}
	}
	return
}

/*
* Width in px of score rendered at scale.
* Digit sprites are not uniform width (1.png is 16px, the rest 24px),
* so widths are summed rather than assumed.
*/
measure_score :: proc(this: ^ScoreDisplay, score: int, scale: f32 = 1.0) -> f32 {
	digits, count := score_digits(score)

	total_width := f32(count - 1) * SCORE_DIGIT_SPACING * scale
	for i in 0 ..< count {
		total_width += f32(this.digit_textures[digits[i]].width) * scale
	}
	return total_width
}

/*
* Draws score with its left edge at left_x, top edge at top_y.
*/
draw_score_at :: proc(this: ^ScoreDisplay, score: int, left_x, top_y: f32, scale: f32 = 1.0) {
	digits, count := score_digits(score)

	x := left_x
	for i := count - 1; i >= 0; i -= 1 {
		tx := this.digit_textures[digits[i]]
		rl.DrawTextureEx(tx, {x, top_y}, 0, scale, rl.WHITE)
		x += (f32(tx.width) + SCORE_DIGIT_SPACING) * scale
	}
}

/*
* Draws score horizontally centered, top edge at top_y.
*/
draw_score :: proc(this: ^ScoreDisplay, score: int, top_y: i32) {
	total_width := measure_score(this, score)
	draw_score_at(this, score, (WINDOW_SIZE_X - total_width) / 2, f32(top_y))
}
