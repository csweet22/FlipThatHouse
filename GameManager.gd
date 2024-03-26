extends Node


var house_scene = preload("res://house.tscn")

var reference_house: Node2D
var your_house: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	init_new_puzzle()

func init_new_puzzle():
	if reference_house != null:
		reference_house.queue_free()
		
	if your_house != null:
		your_house.queue_free()
	
	reference_house = house_scene.instantiate() as Node2D
	reference_house.global_position.x = 250
	add_child(reference_house)
	
	your_house = house_scene.instantiate() as Node2D
	your_house.global_position.x = -250
	add_child(your_house)
	
	reference_house.set_as_reference()
	reference_house.randomize_flips()

func item_flipped():
	var reference_flips: Array[int] = reference_house.get_flip_array()
	var your_flips: Array[int] = your_house.get_flip_array()
	
	if your_flips == reference_flips:
		init_new_puzzle()
	else:
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
