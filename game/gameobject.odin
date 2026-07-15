package game

import b2 "vendor:box2d"
import rl "vendor:raylib"

GameObject :: struct #all_or_none {
	tex:             rl.Texture2D,
	pos:             rl.Vector2,
	size:            rl.Vector2,
	collision_shape: b2.Polygon,
    draw_proc:proc(this: ^GameObject),
    update_proc:proc(this: ^GameObject),
}

draw_gameobject :: proc(this: ^GameObject) {

}
update_gameobject :: proc(this: ^GameObject) {

}
