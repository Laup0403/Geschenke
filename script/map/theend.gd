extends Node2D

@onready var anim = $AnimationPlayer
var state = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(4.0).timeout
	anim.play("einblenden")
	await anim.animation_finished
	state = 1
	print("eingeblendet")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if state == 1 and Input.is_anything_pressed():
		state = 0
		anim.play("ausblenden")
		await anim.animation_finished
		state = 2
	elif state == 2 and Input.is_anything_pressed():
		state = 0
		anim.play("end")
		await anim.animation_finished
		SceneLoader.load_scene("uid://dje34qxya2d2j")
