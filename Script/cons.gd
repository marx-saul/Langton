extends Node

const LANG_STATES = 8
const LANG_COLORS = [
	Color(0.10, 0.10, 0.10, 0.8),
	Color(0.75, 0.10, 0.10, 0.8),
	Color(0.10, 0.75, 0.10, 0.8),
	Color(0.10, 0.10, 0.75, 0.8),
	Color(0.10, 0.75, 0.75, 0.8),
	Color(0.75, 0.10, 0.75, 0.8),
	Color(0.75, 0.75, 0.10, 0.8),
	Color(0.75, 0.75, 0.75, 0.8),
]
const LANG_ANT_COLOR = Color(0.95, 0.95, 0.95, 1.0)

const ORTHOGONAL_DIRS = 8
static func orthogonal_vec2(dir: int) -> Vector2i:
	match dir:
		0:
			return Vector2i(1, 0)
		1:
			return Vector2i(1, 1)
		2:
			return Vector2i(0, 1)
		3:
			return Vector2i(-1, 1)
		4:
			return Vector2i(-1, 0)
		5:
			return Vector2i(-1, -1)
		6:
			return Vector2i(0, -1)
		7:
			return Vector2i(-1, -1)
		_:
			assert(0)
			return Vector2i(0, 0)

const HEX_DIRS = 6
