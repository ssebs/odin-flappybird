#+feature dynamic-literals
package game

WINDOW_SIZE_X: f32 : 288.0
WINDOW_SIZE_Y: f32 : 512.0
GAME_NAME_C: cstring : "Odin Flappybird"

GROUND_MOVE_SPEED: f32 : 68.0
GRAVITY: f32 : -9.8
JUMP: f32 : 300.0
PIPE_GAP: f32 : 120.0 // vertical opening the bird flies through
PIPE_PAIRS :: 2

SCORE_TOP_Y: i32 : 20
SCORE_DIGIT_SPACING: f32 : 1.0

GameState :: enum {
	STOPPED,
	PLAYING,
	DYING,
	// PAUSED,
}

TextureName :: enum {
	BG_DAY,
	BASE,
	PIPE,
	BIRD_DOWNFLAP,
	BIRD_MIDFLAP,
	BIRD_UPFLAP,
	ICON,
	GAMEOVER,
	PREGAME,
	// digits must stay contiguous, draw_score indexes them by offset
	DIGIT_0,
	DIGIT_1,
	DIGIT_2,
	DIGIT_3,
	DIGIT_4,
	DIGIT_5,
	DIGIT_6,
	DIGIT_7,
	DIGIT_8,
	DIGIT_9,
}
SoundName :: enum {
	DIE,
	HIT,
	POINT,
	SWOOSH,
	WING,
}

// map of texture name to rel file path from root of proj
texture_file_name_map := map[TextureName]cstring {
	TextureName.BG_DAY        = "./assets/sprites/background-day.png",
	TextureName.BASE          = "./assets/sprites/base.png",
	TextureName.PIPE          = "./assets/sprites/pipe-green.png",
	TextureName.BIRD_DOWNFLAP = "./assets/sprites/yellowbird-downflap.png",
	TextureName.BIRD_MIDFLAP  = "./assets/sprites/yellowbird-midflap.png",
	TextureName.BIRD_UPFLAP   = "./assets/sprites/yellowbird-upflap.png",
	TextureName.ICON          = "./assets/favicon.png",
	TextureName.GAMEOVER      = "./assets/sprites/gameover.png",
	TextureName.PREGAME       = "./assets/sprites/message.png",
	TextureName.DIGIT_0       = "./assets/sprites/0.png",
	TextureName.DIGIT_1       = "./assets/sprites/1.png",
	TextureName.DIGIT_2       = "./assets/sprites/2.png",
	TextureName.DIGIT_3       = "./assets/sprites/3.png",
	TextureName.DIGIT_4       = "./assets/sprites/4.png",
	TextureName.DIGIT_5       = "./assets/sprites/5.png",
	TextureName.DIGIT_6       = "./assets/sprites/6.png",
	TextureName.DIGIT_7       = "./assets/sprites/7.png",
	TextureName.DIGIT_8       = "./assets/sprites/8.png",
	TextureName.DIGIT_9       = "./assets/sprites/9.png",
}

// map of sound name to rel file path from root of proj
sound_file_name_map := map[SoundName]cstring {
	SoundName.DIE    = "./assets/audio/die.ogg",
	SoundName.HIT    = "./assets/audio/hit.ogg",
	SoundName.POINT  = "./assets/audio/point.ogg",
	SoundName.SWOOSH = "./assets/audio/swoosh.ogg",
	SoundName.WING   = "./assets/audio/wing.ogg",
}
