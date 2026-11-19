extends Node2D

var show = false

func _ready() -> void:
	$Label.text = ""
	var tree = get_tree()
	await tree.create_timer(1).timeout
	$Label.text = "The"
	await tree.create_timer(1).timeout
	$Label.text = "The toilet"
	await tree.create_timer(1).timeout
	$Label.text = "The toilet is"
	await tree.create_timer(1).timeout
	$Label.text = "The toilet is free"
	await tree.create_timer(1).timeout
	$Label.text = "The toilet is free now."
	await tree.create_timer(1).timeout
	show = true

func _process(delta: float) -> void:
	if show and Input.is_action_just_pressed("Everything"):
		Global.toiletFree = true
		Global.kaboom = false
		var sceneRes = load("res://scenes/wiese.tscn")
		var scene = sceneRes.instantiate()
		get_tree().root.add_child(scene)
		scene.player.position = Vector2(2404.0,772.0)
		queue_free()
