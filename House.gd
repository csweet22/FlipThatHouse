extends Node2D

var flippable_objects: Array[Node2D]

func _setup(x_pos: float):
	position.x = DisplayServer.screen_get_size().x + x_pos
	var tween_in = get_tree().create_tween()
	tween_in.set_ease(Tween.EASE_OUT)
	tween_in.set_trans(Tween.TRANS_QUAD)
	tween_in.tween_property(self, "position", Vector2(x_pos, 360), 0.25)

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
	var default_array: Array[int]
	for flip_object in flippable_objects:
		default_array.append(0)
	
	var i = 0
	while get_flip_array() == default_array:
		if i > 0:
			print("REROLL!")
		i += 1
		for flip_object in flippable_objects:
			if randi_range(0, 1) == 1:
				flip_object.flip()

func destroy():
	var x_pos = -DisplayServer.screen_get_size().x + global_position.x
	
	var tween_in = get_tree().create_tween()
	tween_in.set_ease(Tween.EASE_IN)
	tween_in.set_trans(Tween.TRANS_QUAD)
	tween_in.tween_property(self, "position", Vector2(x_pos, 360), 0.25)
	tween_in.finished.connect(queue_free)

func get_all_children(node) -> Array:
	var nodes : Array = []
	for N in node.get_children():
		if N.get_child_count() > 0:
			nodes.append(N)
			nodes.append_array(get_all_children(N))
		else:
			nodes.append(N)
	return nodes
