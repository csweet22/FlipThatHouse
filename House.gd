extends Node2D

var flippable_objects: Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	var all_children = get_all_children(self)
	for child in all_children:
		if child.is_in_group("flip_object"):
			flippable_objects.append(child)

func set_as_reference():
	for flip_object in flippable_objects:
		flip_object.set_not_interactable()

func init_flips(flips: Array[int]):
	for index in range(len(flippable_objects)):
		if flips[index] == 1:
			flippable_objects[index].flip()

func get_flip_array() -> Array[int]:
	var flip_array: Array[int]
	
	for flip_object in flippable_objects:
		flip_array.append(1 if flip_object.flipped else 0)
	
	return flip_array

func randomize_flips():
	for flip_object in flippable_objects:
		if randi_range(0, 1) == 1:
			flip_object.flip()

func get_all_children(node) -> Array:
	var nodes : Array = []
	for N in node.get_children():
		if N.get_child_count() > 0:
			nodes.append(N)
			nodes.append_array(get_all_children(N))
		else:
			nodes.append(N)
	return nodes
