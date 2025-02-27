extends Node

enum LayerValues {
	GLOBAL = 1,
	PLAYER = 2,
	WINDOWBORDERS = 3,
	WINDOWS = 4,
	CONTAINER = 5,		#contaianer sets it's children's layer mask to this and then sets/disables this layer on objects that collide into it
}
enum LayerMasks {
	GLOBAL = 1 << (LayerValues.GLOBAL - 1),
	PLAYER = 1 << (LayerValues.PLAYER - 1),
	WINDOWBORDERS = 1 << (LayerValues.WINDOWBORDERS - 1),
	WINDOWS = 1 << (LayerValues.WINDOWS - 1),
	CONTAINER = 1 << (LayerValues.CONTAINER - 1)
}

enum WindowButtonType {
	CLOSE = 0,
	MINIMIZE = 1
}

enum FileType {
	ROOT = 0,
	DIRECTORY = 1,
	TEXT = 2,
	EXEC = 3,
}
