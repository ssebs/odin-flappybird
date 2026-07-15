#+feature dynamic-literals
package main

WINDOW_SIZE_X := 288
WINDOW_SIZE_Y := 512
GAME_NAME_C: cstring = "Odin Flappybird"

// map of texture name to rel file path from root of proj
texture_file_name_map := map[string]string {
	"bg-day"        = "./assets/sprites/background-day.png",
	"base"          = "./assets/sprites/base.png",
	"pipe"          = "./assets/sprites/pipe.png",
	"bird-downflap" = "./assets/sprites/bird-downflap.png",
	"bird-midflap"  = "./assets/sprites/bird-midflap.png",
	"bird-upflap"   = "./assets/sprites/bird-upflap.png",
}

// map of sound name to rel file path from root of proj
sound_file_name_map := map[string]string {
	"die"    = "./assets/audio/die.ogg",
	"hit"    = "./assets/audio/hit.ogg",
	"point"  = "./assets/audio/point.ogg",
	"swoosh" = "./assets/audio/swoosh.ogg",
	"wing"   = "./assets/audio/wing.ogg",
}
