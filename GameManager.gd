extends Node


var house_scene = preload("res://house.tscn")
var gameover_scene = preload("res://game_over_screen.tscn")

var reference_house: Node2D
var your_house: Node2D

var finish_timer: Timer

var solve_timer: Timer

var solve_duration: float = 5.0

var game_over_scene: Node

var puzzles_solved: int = 0

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
	reference_house.global_position = Vector2(10000, 360)
	add_child(reference_house)
	reference_house._setup(864)
	
	your_house = house_scene.instantiate() as Node2D
	your_house.global_position = Vector2(10000, 360)
	add_child(your_house)
	your_house._setup(288)
	
	reference_house.set_as_reference()
	reference_house.randomize_flips()
	
	if solve_timer != null:
		solve_timer.paused = false
		solve_timer.wait_time *= 0.8
		solve_timer.start()

func finish_timer_finished():
	init_new_puzzle()

func solve_timer_finished():
	game_over()

func game_over():
	game_over_scene = gameover_scene.instantiate()
	get_tree().root.add_child(game_over_scene)
	your_house.set_as_reference()

func solved_puzzle():
	puzzles_solved += 1
	finish_timer.start()
	solve_timer.paused = true
	your_house.set_as_reference()

func item_flipped():
	var reference_flips: Array[int] = reference_house.get_flip_array()
	var your_flips: Array[int] = your_house.get_flip_array()
	
	if your_flips == reference_flips:
		solved_puzzle()
	else:
		pass

func restart():
	game_over_scene.queue_free()
	solve_timer.wait_time = solve_duration
	solve_timer.start()
	init_new_puzzle()
	puzzles_solved = 0
