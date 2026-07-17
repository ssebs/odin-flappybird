// assets.odin - assets are embedded into the binary at compile time, so the
// shipped exe runs standalone with no ./assets folder next to it. #load paths
// are relative to this source file, not the working directory.
package game

import rl "vendor:raylib"

@(private)
texture_data := [TextureName][]byte {
	.BG_DAY        = #load("../assets/sprites/background-day.png"),
	.BASE          = #load("../assets/sprites/base.png"),
	.PIPE          = #load("../assets/sprites/pipe-green.png"),
	.BIRD_DOWNFLAP = #load("../assets/sprites/yellowbird-downflap.png"),
	.BIRD_MIDFLAP  = #load("../assets/sprites/yellowbird-midflap.png"),
	.BIRD_UPFLAP   = #load("../assets/sprites/yellowbird-upflap.png"),
	.ICON          = #load("../assets/favicon.png"),
	.GAMEOVER      = #load("../assets/sprites/gameover.png"),
	.PREGAME       = #load("../assets/sprites/message.png"),
	.DIGIT_0       = #load("../assets/sprites/0.png"),
	.DIGIT_1       = #load("../assets/sprites/1.png"),
	.DIGIT_2       = #load("../assets/sprites/2.png"),
	.DIGIT_3       = #load("../assets/sprites/3.png"),
	.DIGIT_4       = #load("../assets/sprites/4.png"),
	.DIGIT_5       = #load("../assets/sprites/5.png"),
	.DIGIT_6       = #load("../assets/sprites/6.png"),
	.DIGIT_7       = #load("../assets/sprites/7.png"),
	.DIGIT_8       = #load("../assets/sprites/8.png"),
	.DIGIT_9       = #load("../assets/sprites/9.png"),
}

@(private)
sound_data := [SoundName][]byte {
	.DIE    = #load("../assets/audio/die.ogg"),
	.HIT    = #load("../assets/audio/hit.ogg"),
	.POINT  = #load("../assets/audio/point.ogg"),
	.SWOOSH = #load("../assets/audio/swoosh.ogg"),
	.WING   = #load("../assets/audio/wing.ogg"),
}

@(private)
font_data := #load("../assets/FlappyBirdRegular.ttf")

@(private = "file")
load_image :: proc(name: TextureName) -> rl.Image {
	data := texture_data[name]
	return rl.LoadImageFromMemory(".png", raw_data(data), i32(len(data)))
}

load_texture :: proc(name: TextureName) -> rl.Texture {
	img := load_image(name)
	defer rl.UnloadImage(img)
	return rl.LoadTextureFromImage(img)
}

/*
* The window icon, for main to hand to rl.SetWindowIcon before any texture
* loading needs the audio/GL context.
*/
load_icon_image :: proc() -> rl.Image {
	return load_image(TextureName.ICON)
}

load_sound :: proc(name: SoundName) -> rl.Sound {
	data := sound_data[name]
	wave := rl.LoadWaveFromMemory(".ogg", raw_data(data), i32(len(data)))
	defer rl.UnloadWave(wave)
	return rl.LoadSoundFromWave(wave)
}

/*
* Loaded at its render size, point filtered, so the pixel font stays sharp.
*/
load_hud_font :: proc() -> rl.Font {
	f := rl.LoadFontFromMemory(
		".ttf",
		raw_data(font_data),
		i32(len(font_data)),
		i32(HUD_FONT_SIZE),
		nil,
		0,
	)
	rl.SetTextureFilter(f.texture, rl.TextureFilter.POINT)
	return f
}
