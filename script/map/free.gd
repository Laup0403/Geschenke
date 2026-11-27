extends Node2D

var fullyShown = false

func _ready() -> void:
	$Label.text = ""
	var tree = get_tree()
	await tree.create_timer(1).timeout
	$Label.text = "The"
	Audio.play_sound("uid://bko3yj7mvan3g", -20, true)
	await tree.create_timer(1).timeout
	$Label.text = "The toilet"
	Audio.play_sound("uid://bko3yj7mvan3g", -20, true)
	await tree.create_timer(1).timeout
	$Label.text = "The toilet is"
	Audio.play_sound("uid://l28yhj6jn6b2", -20, true)
	await tree.create_timer(1).timeout
	$Label.text = "The toilet is free"
	Audio.play_sound("uid://l28yhj6jn6b2", -20, true)
	await tree.create_timer(1).timeout
	$Label.text = "The toilet is free now."
	Audio.play_sound("uid://cw2p87ownkkyy", -20, true)
	await tree.create_timer(1).timeout
	fullyShown = true

func _process(_delta: float) -> void:
	if fullyShown and Input.is_action_just_pressed("Everything"):
		Global.toiletFree = true
		Global.kaboom = false
		Global.newPlayerPos = Vector2(8569.0,772.0)
		SceneLoader.load_scene("uid://khnvv4e0ipum")
