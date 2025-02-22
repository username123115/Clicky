extends Node

enum LayerValues {
	GLOBAL = 1,
	PLAYER = 2,
	WINDOWBORDERS = 3,
	WINDOWS = 4
}
enum LayerMasks {
	GLOBAL = 1 << (LayerValues.GLOBAL - 1),
	PLAYER = 1 << (LayerValues.PLAYER - 1),
	WINDOWBORDERS = 1 << (LayerValues.WINDOWBORDERS - 1),
	WINDOWS = 1 << (LayerValues.WINDOWS - 1)
}

enum FileType {
	ROOT,
	DIRECTORY,
	TEXT
}
