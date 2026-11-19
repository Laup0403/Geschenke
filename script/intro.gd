extends Node2D

var timer = 2

func _ready() -> void:
	$Player.visible = false
	$Today.visible = false
	$YouAre.visible = false
	$Name.visible = false
	$Player.play("idle")
	
	$Name.text = Global.username + "!"
	
	if Global.kaboom:
		$Today.text = "Now"
		$Player.play("grusel")
		Global.chapter2 = true

func _process(delta: float) -> void:
	if timer <= 0:
		if not $Today.visible:
			$Today.visible = true
			timer = 2
		elif not $YouAre.visible:
			$YouAre.visible = true
			timer = 2
		elif not $Name.visible:
			$Name.visible = true
			$Player.visible = true
		elif Input.is_action_just_pressed("Everything"):
			var sceneRes = load("res://scenes/house.tscn")
			var scene = sceneRes.instantiate()
			get_tree().root.add_child(scene)
			scene.player.position = Vector2(-4424.0,1181.0)
			queue_free()
	else:
		timer -= delta
