package game

import rl "vendor:raylib"

/*
* A checkbox that compresses the difficulty ramp, drawn under the volume slider.
* Off on every launch, unlike the volume, which is saved.
*/
FastToggle :: struct {
	enabled: bool,
	hovered: bool,
}

init_fast_toggle :: proc() -> FastToggle {
	return FastToggle{enabled = false, hovered = false}
}

@(private = "file")
fast_box_y :: proc() -> f32 {
	// the box is centered on the text row rather than sharing its top edge
	return FAST_ROW_Y + (HUD_FONT_SIZE - FAST_BOX_SIZE) / 2
}

@(private = "file")
fast_box_rect :: proc() -> rl.Rectangle {
	return rl.Rectangle {
		x = FAST_BOX_X,
		y = fast_box_y(),
		width = FAST_BOX_SIZE,
		height = FAST_BOX_SIZE,
	}
}

/*
* Click target covering the box and its label, so the word is clickable too.
*/
@(private = "file")
fast_toggle_rect :: proc() -> rl.Rectangle {
	label_width := measure_hud_text(FAST_LABEL)
	return rl.Rectangle {
		x = FAST_BOX_X,
		y = FAST_ROW_Y,
		width = FAST_BOX_SIZE + FAST_LABEL_GAP + label_width,
		height = HUD_FONT_SIZE,
	}
}

/*
* Only sets the cursor when hovered, leaving the reset to the caller.
*/
update_fast_toggle :: proc(this: ^FastToggle) {
	this.hovered = rl.CheckCollisionPointRec(get_mouse_native_pos(), fast_toggle_rect())
	if this.hovered {
		rl.SetMouseCursor(rl.MouseCursor.POINTING_HAND)
	}

	if this.hovered && rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
		this.enabled = !this.enabled
	}
}

draw_fast_toggle :: proc(this: ^FastToggle) {
	box := fast_box_rect()

	rl.DrawRectangleRec(box, HUD_OUTLINE_COLOR)

	fill := rl.WHITE
	if this.enabled {
		fill = PLAY_BTN_HOVER_COLOR if this.hovered else PLAY_BTN_COLOR
	}
	rl.DrawRectangleRec(
		rl.Rectangle {
			x = box.x + FAST_BOX_BORDER,
			y = box.y + FAST_BOX_BORDER,
			width = box.width - FAST_BOX_BORDER * 2,
			height = box.height - FAST_BOX_BORDER * 2,
		},
		fill,
	)

	draw_hud_text(FAST_LABEL, box.x + box.width + FAST_LABEL_GAP, FAST_ROW_Y)
}
