package game

import rl "vendor:raylib"

/*
* Checkbox that packs the difficulty ramp into a much shorter score.
* Not saved, so it starts off every launch.
*/
FastToggle :: struct {
	enabled: bool,
	hovered: bool,
}

@(private = "file")
fast_box_rect :: proc() -> rl.Rectangle {
	return rl.Rectangle{FAST_BOX_X, FAST_BOX_Y, FAST_BOX_SIZE, FAST_BOX_SIZE}
}

/*
* Click target. Covers the label too, so the word is clickable.
*/
@(private = "file")
fast_hit_rect :: proc() -> rl.Rectangle {
	width := FAST_LABEL_X - FAST_BOX_X + measure_hud_text(FAST_LABEL)
	return rl.Rectangle{FAST_BOX_X, FAST_LABEL_Y, width, HUD_FONT_SIZE}
}

update_fast_toggle :: proc(this: ^FastToggle) {
	this.hovered = rl.CheckCollisionPointRec(get_mouse_native_pos(), fast_hit_rect())
	if this.hovered {
		rl.SetMouseCursor(rl.MouseCursor.POINTING_HAND)

		if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
			this.enabled = !this.enabled
		}
	}
}

draw_fast_toggle :: proc(this: ^FastToggle) {
	box := fast_box_rect()
	rl.DrawRectangleRec(box, HUD_OUTLINE_COLOR)

	fill := rl.WHITE
	if this.enabled {
		fill = PLAY_BTN_HOVER_COLOR if this.hovered else PLAY_BTN_COLOR
	}
	rl.DrawRectangleRec({box.x + 1, box.y + 1, box.width - 2, box.height - 2}, fill)

	draw_hud_text(FAST_LABEL, FAST_LABEL_X, FAST_LABEL_Y)
}
