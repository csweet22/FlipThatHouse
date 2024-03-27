extends Node


var house_scene = preload("res://house.tscn")

var reference_house: Node2D
var your_house: Node2D

var finish_timer: Timer

var solve_timer: Timer

var solve_duration: float = 30.0

# Called when the node enters the scene tree for the first time.
func _ready():
	init_new_puzzle()
	
	finish_timer = Timer.new()
	finish_timer.autostart = false
	finish_timer.one_shot = true
	finish_timer.wait_time = 1.0
	
	finish_timer.timeout.connect(finish_timer_finished)
	
	add_child(finish_timer)
	
	solve_timer = Timer.new()
	solve_timer.autostart = true
	solve_timer.one_shot = true
	solve_timer.wait_time = solve_duration
	
	solve_timer.timeout.connect(solve_timer_finished)
	
	add_child(solve_timer)

func init_new_puzzle():
	if reference_house != null:
		reference_house.destroy()
		
	if your_house != null:
		your_house.destroy()
	
	reference_house = house_scene.instantiate() as Node2D
	reference_house.global_position = Vector2(10000, 0)
	add_child(reference_house)
	reference_house._setup(250)
	
	your_house = house_scene.instantiate() as Node2D
	your_house.global_position = Vector2(10000, 0)
	add_child(your_house)
	your_house._setup(-250)
	
	reference_house.set_as_reference()
	reference_house.randomize_flips()

func finish_timer_finished():
	init_new_puzzle()

func solve_timer_finished():
	game_over()

func game_over():
	print("GAME OVER!")
	your_house.set_as_reference()

func solved_puzzle():
	finish_timer.start()
	solve_timer.wait_time *= 0.8
	solve_timer.start()
	your_house.set_as_reference()

func item_flipped():
	var reference_flips: Array[int] = reference_house.get_flip_array()
	var your_flips: Array[int] = your_house.get_flip_array()
	
	if your_flips == reference_flips:
		solved_puzzle()
	else:
		pass
