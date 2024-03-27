extends Node2D

@export var flipped: bool = false

var rotation_tween: Tween

var Pivot: Node2D

var target_rotation: float = 0

var bitmask: Image

# Called when the node enters the scene tree for the first time.
func _ready():
	Pivot = $"."
	var test = BitMap.new()
	test.create_from_image_alpha(($FlipButton as TextureButton).texture_normal.get_image())
	($FlipButton as TextureButton).texture_click_mask = test


func _on_flip_button_pressed():
	flip()

func set_not_interactable():
	($FlipButton as TextureButton).disabled = true

func flip():
	flipped = not flipped
	
	if rotation_tween:
		rotation_tween.kill()
	target_rotation += 180
	rotation_tween = get_tree().create_tween()
	rotation_tween.set_ease(Tween.EASE_OUT)
	rotation_tween.set_trans(Tween.TRANS_SPRING)
	rotation_tween.tween_property(Pivot, "rotation_degrees", target_rotation, 0.25)

	GameManager.item_flipped()
