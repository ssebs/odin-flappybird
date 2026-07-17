package game

import rl "vendor:raylib"

hud_font: rl.Font

HUD :: struct #all_or_none {
	using game_object: GameObject,
	gameover_texture:  rl.Texture,
	pregame_texture:   rl.Texture,
	score_display:     ScoreDisplay,
	score:             int,
	high_score:        int,
	volume_slider:     VolumeSlider,
	fast_toggle:       FastToggle,
	play_hovered:      bool,
}

NewHUD :: proc() -> ^HUD {
	gameover_tx := load_texture(TextureName.GAMEOVER)
	pregame_tx := load_texture(TextureName.PREGAME)

	hud_font = load_hud_font()

	h: ^HUD = &HUD {
		game_object = GameObject {
			update_proc = update_hud,
			draw_proc = draw_hud,
			exit_proc = exit_hud,
		},
		gameover_texture = gameover_tx,
		pregame_texture = pregame_tx,
		score_display = init_score_display(),
		score = 0,
		high_score = 0,
		volume_slider = init_volume_slider(DEFAULT_VOL),
		fast_toggle = {},
		play_hovered = false,
	}
	return h
}
@(private = "file")
exit_hud :: proc(this: ^HUD) {
	rl.UnloadTexture(this.gameover_texture)
	rl.UnloadTexture(this.pregame_texture)
	rl.UnloadFont(hud_font)
	exit_score_display(&this.score_display)
}
@(private = "file")
draw_hud :: proc(this: ^HUD) {
	draw_high_score(this)

	if game_state == GameState.PLAYING {
		draw_score(&this.score_display, this.score, SCORE_TOP_Y)
	} else if game_state == GameState.DYING {
		mid_x := f32(WINDOW_SIZE_X) / 2 - f32(this.gameover_texture.width) / 2
		rl.DrawTextureEx(this.gameover_texture, rl.Vector2{mid_x, 80}, 0, 1.0, rl.WHITE)
	} else if game_state == GameState.STOPPED {
		mid_x := f32(WINDOW_SIZE_X) / 2 - f32(this.pregame_texture.width) / 2
		rl.DrawTextureEx(this.pregame_texture, {mid_x, 88}, 0, 1.0, rl.WHITE)
		draw_volume_slider(&this.volume_slider)
		draw_fast_toggle(&this.fast_toggle)
		draw_play_button(this)
	}
}
/*
* White with a 1px dark outline, matching how the sprites are drawn.
*/
draw_hud_text :: proc(text: cstring, x, y: f32) {
	outline := [4]rl.Vector2{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
	for o in outline {
		rl.DrawTextEx(
			hud_font,
			text,
			{x + o.x, y + o.y},
			HUD_FONT_SIZE,
			HUD_FONT_SPACING,
			HUD_OUTLINE_COLOR,
		)
	}
	rl.DrawTextEx(hud_font, text, {x, y}, HUD_FONT_SIZE, HUD_FONT_SPACING, rl.WHITE)
}

measure_hud_text :: proc(text: cstring) -> f32 {
	return rl.MeasureTextEx(hud_font, text, HUD_FONT_SIZE, HUD_FONT_SPACING).x
}

/*
* The label stacked above the digits, both right-aligned in the top corner.
* Drawn smaller than the live score so it reads as secondary.
*/
@(private = "file")
draw_high_score :: proc(this: ^HUD) {
	right_x := WINDOW_SIZE_X - HIGH_SCORE_MARGIN_X

	label_width := measure_hud_text(HIGH_SCORE_LABEL)
	draw_hud_text(HIGH_SCORE_LABEL, right_x - label_width, HIGH_SCORE_TOP_Y)

	digits_width := measure_score(&this.score_display, this.high_score, HIGH_SCORE_SCALE)
	draw_score_at(
		&this.score_display,
		this.high_score,
		right_x - digits_width,
		HIGH_SCORE_TOP_Y + HUD_FONT_SIZE + HIGH_SCORE_LABEL_GAP,
		HIGH_SCORE_SCALE,
	)
}

play_btn_rect :: proc() -> rl.Rectangle {
	return rl.Rectangle {
		x = (WINDOW_SIZE_X - PLAY_BTN_W) / 2,
		y = PLAY_BTN_Y,
		width = PLAY_BTN_W,
		height = PLAY_BTN_H,
	}
}

/*
* The only way to start a run, apart from SPACE. Also tracks hover for the
* cursor and the highlight.
*/
update_play_button :: proc(this: ^HUD) -> (clicked: bool) {
	this.play_hovered = rl.CheckCollisionPointRec(get_mouse_native_pos(), play_btn_rect())
	if this.play_hovered {
		rl.SetMouseCursor(rl.MouseCursor.POINTING_HAND)
	}
	return this.play_hovered && rl.IsMouseButtonPressed(rl.MouseButton.LEFT)
}

@(private = "file")
draw_play_button :: proc(this: ^HUD) {
	rect := play_btn_rect()

	rl.DrawRectangleRec(rect, HUD_OUTLINE_COLOR)
	rl.DrawRectangleRec(
		rl.Rectangle {
			x = rect.x + PLAY_BTN_BORDER,
			y = rect.y + PLAY_BTN_BORDER,
			width = rect.width - PLAY_BTN_BORDER * 2,
			height = rect.height - PLAY_BTN_BORDER * 2,
		},
		PLAY_BTN_HOVER_COLOR if this.play_hovered else PLAY_BTN_COLOR,
	)

	label_width := measure_hud_text(PLAY_BTN_LABEL)
	draw_hud_text(
		PLAY_BTN_LABEL,
		rect.x + (rect.width - label_width) / 2,
		rect.y + (rect.height - HUD_FONT_SIZE) / 2,
	)
}

@(private = "file")
update_hud :: proc(this: ^HUD) {}
