extends Node2D

@onready var player = $Player
@onready var textbox = $Textbox

var area = "none"
var is_fade = false
var end = false

func _ready() -> void:
	if Global.newPlayerPos != Vector2.ZERO:
		player.position = Global.newPlayerPos
		Global.newPlayerPos = Vector2.ZERO
	
	if Global.fatherSpoken:
		player.animation = "grusel"
		$EndCutscene.show()
		$Map/Walls/CollisionShape2D2.position.x = 2686.0
		$"Map/könig/CollisionShape2D".disabled = true
	elif Global.chapter2:
		player.animation = "grusel"
		$"Map/könig/CollisionShape2D".disabled = false
		Global.kaboom = false
	elif Global.kaboom:
		$Map.visible = false
		$"Map/könig/CollisionShape2D".disabled = true
		$RoterWackelpudding.visible = true

	$Map/Soldat.play("default")
	$Map/Soldat2.play("default")
	$Map/Soldat3.play("default")
	$Map/Soldat4.play("default")

func _process(_delta: float) -> void:
	if end:
		if Input.is_anything_pressed():
			get_tree().quit()
		return
	
	if area == "könig" and Input.is_action_just_pressed("Up") and textbox.is_ready() and not Global.kaboom:
		if Global.chapter2:
			textbox.addText("Get out of my kingdom!")
		elif Global.presentReceived:
			textbox.addText("Go home to your father")
		else:
			textbox.addText("Hello young man")
			textbox.addText("Oh you have a present for me?")
			textbox.addText("Thank you.\nYou can go tell your father I received it")
			Global.presentReceived = true
	
	if Global.chapter2:
		if player.position.x >= 2530.0:
			$Map/Walls/CollisionShape2D3.disabled = false

func _exited(body: Node2D) -> void:
	if body == player:
		player.notInteract()
		area = "none"
func _tür_entered(body: Node2D) -> void:
	if body == player:
		Global.newPlayerPos = Vector2(9633.0,696.0)
		if not Global.presentReceived:
			Audio.change_bg_music("uid://cge8jhi3grnac", -20)
		elif not Global.kaboom:
			Audio.clear_bg_music(4.0)
		if Global.fatherSpoken:
			Audio.beeb()
		SceneLoader.load_scene("uid://khnvv4e0ipum")
func _könig_entered(body: Node2D) -> void:
	if body == player and not Global.kaboom:
		player.interact()
		area = "könig"
func _on_end_triggered(body: Node2D) -> void:
	if body == player and not $Map/Walls/CollisionShape2D3.disabled and not is_fade:
		player.canMove = false
		is_fade = true
		await get_tree().create_timer(1.).timeout
		Audio.beeb()
		textbox.addText("Wait.")
		textbox.addText("I can't get out.", func(): 
			Audio.clear_bg_music(40.0)
			await get_tree().create_timer(5.).timeout
			fade()
			textbox.addText("I'm so sorry father")
			await get_tree().create_timer(33.).timeout
			Audio.queue_free()
			var bus := AudioServer.get_bus_index("Master")
			AudioServer.set_bus_effect_enabled(bus, 0, false)
			AudioServer.set_bus_effect_enabled(bus, 1, false)
			Global.crt = false
			get_tree().change_scene_to_file("uid://detgq55kpou5p")
		)

func fade() -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(
		func(val: float): $Dissolve/ColorRect.material.set_shader_parameter("dissolve_value", val),
		0.0,
		1.0,
		30.0
	)
