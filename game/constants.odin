#+feature dynamic-literals
package game

import rl "vendor:raylib"

WINDOW_SIZE_X: f32 : 288.0
WINDOW_SIZE_Y: f32 : 512.0
GAME_NAME_C: cstring : "Odin Flappybird"
SAVE_GAME_NAME: string : "odin-flappybird-save.ini"

// save file keys. score falls back to its zero value when absent
SAVE_KEY_SCORE: string : "SCORE"
SAVE_KEY_VOL: string : "VOL"
// must be one of VOLUME_STOPS, or load snaps it to the nearest one
DEFAULT_VOL: f32 : 1.0

GROUND_MOVE_SPEED: f32 : 68.0
GRAVITY: f32 : -9.8
JUMP: f32 : 300.0
PIPE_GAP: f32 : 120.0 // vertical opening the bird flies through
PIPE_PAIRS :: 2

SCORE_TOP_Y: i32 : 20
SCORE_DIGIT_SPACING: f32 : 1.0

HUD_FONT_FILE: cstring : "./assets/FlappyBirdRegular.ttf"
HUD_FONT_SIZE: f32 : 24.0
HUD_FONT_SPACING: f32 : 1.0
// the dark outline the sprites are drawn with, reused so HUD chrome matches
HUD_OUTLINE_COLOR :: rl.Color{84, 56, 71, 255}

HIGH_SCORE_LABEL: cstring : "HI"
HIGH_SCORE_SCALE: f32 : 0.5
HIGH_SCORE_TOP_Y: f32 : 6.0
HIGH_SCORE_MARGIN_X: f32 : 6.0
// vertical gap between the label and the digits under it
HIGH_SCORE_LABEL_GAP: f32 : 2.0

// play button, in the gap between the pregame message and the ground
PLAY_BTN_LABEL: cstring : "PLAY"
PLAY_BTN_W: f32 : 96.0
PLAY_BTN_H: f32 : 28.0
PLAY_BTN_Y: f32 : 366.0
PLAY_BTN_BORDER: f32 : 2.0
PLAY_BTN_COLOR :: rl.Color{116, 191, 46, 255} // pipe green
PLAY_BTN_HOVER_COLOR :: rl.Color{140, 214, 68, 255}

// volume slider. only shown on the pregame screen, since LEFT click flaps otherwise
VOLUME_STOPS :: [4]f32{0.0, 0.33, 0.5, 1.0}
VOLUME_LABEL: cstring : "VOLUME"
VOLUME_LABEL_Y: f32 : 14.0
VOLUME_TRACK_X: f32 : 12.0
VOLUME_TRACK_Y: f32 : 40.0
VOLUME_TRACK_W: f32 : 78.0
VOLUME_TRACK_H: f32 : 2.0
VOLUME_DOT_R: f32 : 3.0
VOLUME_DOT_HOVER_R: f32 : 4.0
VOLUME_HANDLE_W: f32 : 6.0
VOLUME_HANDLE_H: f32 : 16.0
// invisible, generous hit area around each stop
VOLUME_BTN_SIZE: f32 : 16.0

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
