extends Node

class_name FileNode

@export var type := Enums.FileType.TEXT	#enum specifying type
@export var data : String			#can be whatever, depends on type
@export var scene : PackedScene			#scene this node loads

func tranverse(target : String, blacklist : Array[FileNode] = [], root : FileNode = null, force_abs : bool = false):
	if target.begins_with('/'):
		return get_root().tranverse(target.get_slice("/", 1), blacklist, root, force_abs)
	return tranverse_arr(target.split("/"), blacklist, root, force_abs)

	
func tranverse_arr(target : Array[String], blacklist : Array[FileNode], root : FileNode = null, force_abs : bool = false) -> FileNode:

	var remaining := target.slice(1, -1)
	if self in blacklist:
		var leaving = (len(target) != 0) and target[0] == ".."
		if not leaving:
			return null

	if len(target) == 0:
		return self

	if force_abs and (target[0] != "/"):
		return null
	force_abs = false

	match target[0]:
		"/":
			if root:
				return root.tranverse_arr(remaining, blacklist, root, force_abs)
			return get_root().tranverse_arr(remaining, blacklist, root, force_abs)
		"..":
			if is_root() or (self == root):
				return self
			var p = fs_get_parent()
			if !p:
				return null
			return p.tranverse_arr(remaining, blacklist, root, force_abs)
		".":
			return self
		_:
			var child = get_node(target[0])
			if !child:
				return null
			return child.tranverse_arr(remaining, blacklist, root, force_abs)

func is_childless() -> bool:
	return get_child_count() > 0


func fs_find_parent(p : FileNode) -> FileNode:
	if (self == p):
		return self

	if is_root():
		return null
	
	if (p == null):
		return get_root()

	return fs_get_parent().fs_find_parent(p)

func fs_get_parent() -> FileNode:
	if is_root():
		return null
	return get_parent() as FileNode

func get_root() -> FileNode:
	if is_root():
		return self
	return fs_get_parent().get_root()

func is_root() -> bool:
	return type == Enums.FileType.ROOT
