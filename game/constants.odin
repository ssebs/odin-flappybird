#+feature dynamic-literals
package game

WINDOW_SIZE_X := 288
WINDOW_SIZE_Y := 512
GAME_NAME_C: cstring = "Odin Flappybird"

TextureName :: enum {
	BG_DAY,
	BASE,
	PIPE,
	BIRD_DOWNFLAP,
	BIRD_MIDFLAP,
	BIRD_UPFLAP,
}
SoundName :: enum {
	DIE,
	HIT,
	POINT,
	SWOOSH,
	WING,
}

// map of texture name to rel file path from root of proj
texture_file_name_map := map[TextureName]string {
	TextureName.BG_DAY        = "./assets/sprites/background-day.png",
	TextureName.BASE          = "./assets/sprites/base.png",
	TextureName.PIPE          = "./assets/sprites/pipe-green.png",
	TextureName.BIRD_DOWNFLAP = "./assets/sprites/yellowbird-downflap.png",
	TextureName.BIRD_MIDFLAP  = "./assets/sprites/yellowbird-midflap.png",
	TextureName.BIRD_UPFLAP   = "./assets/sprites/yellowbird-upflap.png",
}

// map of sound name to rel file path from root of proj
sound_file_name_map := map[SoundName]string {
	SoundName.DIE    = "./assets/audio/die.ogg",
	SoundName.HIT    = "./assets/audio/hit.ogg",
	SoundName.POINT  = "./assets/audio/point.ogg",
	SoundName.SWOOSH = "./assets/audio/swoosh.ogg",
	SoundName.WING   = "./assets/audio/wing.ogg",
}
