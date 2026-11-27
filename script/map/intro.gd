extends Node2D

var timer = 2
var input = false

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
			Audio.play_sound("uid://bko3yj7mvan3g", -20)
			timer = 2
		elif not $YouAre.visible:
			$YouAre.visible = true
			Audio.play_sound("uid://l28yhj6jn6b2", -20)
			timer = 2
		elif not $Name.visible:
			$Name.visible = true
			Audio.play_sound("uid://cw2p87ownkkyy", -20)
			$Player.visible = true
		elif not input:
			input = true
			timer = 1
		elif Input.is_action_just_pressed("Everything"):
			Global.newPlayerPos = Vector2(-4424.0,1181.0)
			Audio.change_bg_music("uid://cumguhr2mejnb", -20, 10)
			SceneLoader.load_scene("uid://dk3eaxbyosm2i")
			queue_free()
	else:
		timer -= delta
