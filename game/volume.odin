package game

import rl "vendor:raylib"

/*
* Four fixed stops (mute / 33 / 50 / 100) drawn as small buttons along a
* horizontal track, with a thin rect marking the selected one.
*/
VolumeSlider :: struct {
	stop:    int, // index into VOLUME_STOPS
	hovered: int, // index under the mouse, or -1
}

init_volume_slider :: proc(vol: f32) -> VolumeSlider {
	return VolumeSlider{stop = nearest_volume_stop(vol), hovered = -1}
}

/*
* Snaps an arbitrary volume (eg. a hand-edited save) to the closest stop.
*/
@(private = "file")
nearest_volume_stop :: proc(vol: f32) -> int {
	stops := VOLUME_STOPS
	best := 0
	for v, i in stops {
		if abs(v - vol) < abs(stops[best] - vol) {
			best = i
		}
	}
	return best
}

@(private = "file")
volume_stop_x :: proc(i: int) -> f32 {
	stops := VOLUME_STOPS
	return VOLUME_TRACK_X + VOLUME_TRACK_W * f32(i) / f32(len(stops) - 1)
}

/*
* Click target for a stop. Deliberately larger than the tick drawn at it.
*/
@(private = "file")
volume_btn_rect :: proc(i: int) -> rl.Rectangle {
	return rl.Rectangle {
		x = volume_stop_x(i) - VOLUME_BTN_SIZE / 2,
		y = VOLUME_TRACK_Y - VOLUME_BTN_SIZE / 2,
		width = VOLUME_BTN_SIZE,
		height = VOLUME_BTN_SIZE,
	}
}

update_volume_slider :: proc(this: ^VolumeSlider) {
	stops := VOLUME_STOPS
	mouse := get_mouse_native_pos()

	this.hovered = -1
	for i in 0 ..< len(stops) {
		if rl.CheckCollisionPointRec(mouse, volume_btn_rect(i)) {
			this.hovered = i
			break
		}
	}

	if this.hovered >= 0 {
		rl.SetMouseCursor(rl.MouseCursor.POINTING_HAND)
	}

	if this.hovered < 0 || !rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
		return
	}

	if this.stop != this.hovered {
		this.stop = this.hovered
		set_master_volume(stops[this.hovered])
	}
}

draw_volume_slider :: proc(this: ^VolumeSlider) {
	stops := VOLUME_STOPS

	draw_hud_text(VOLUME_LABEL, VOLUME_TRACK_X, VOLUME_LABEL_Y)

	rl.DrawRectangleRec(
		rl.Rectangle {
			x = VOLUME_TRACK_X,
			y = VOLUME_TRACK_Y - VOLUME_TRACK_H / 2,
			width = VOLUME_TRACK_W,
			height = VOLUME_TRACK_H,
		},
		HUD_OUTLINE_COLOR,
	)

	// a dot marks each stop, the click target around it stays invisible
	for i in 0 ..< len(stops) {
		radius := VOLUME_DOT_HOVER_R if i == this.hovered else VOLUME_DOT_R
		rl.DrawCircleV({volume_stop_x(i), VOLUME_TRACK_Y}, radius, HUD_OUTLINE_COLOR)
	}

	handle := rl.Rectangle {
		x      = volume_stop_x(this.stop) - VOLUME_HANDLE_W / 2,
		y      = VOLUME_TRACK_Y - VOLUME_HANDLE_H / 2,
		width  = VOLUME_HANDLE_W,
		height = VOLUME_HANDLE_H,
	}
	rl.DrawRectangleRec(handle, HUD_OUTLINE_COLOR)
	rl.DrawRectangleRec(
		rl.Rectangle {
			x = handle.x + 1,
			y = handle.y + 1,
			width = handle.width - 2,
			height = handle.height - 2,
		},
		rl.WHITE,
	)
}
