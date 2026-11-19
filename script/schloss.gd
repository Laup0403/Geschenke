extends Node2D

@onready var player = $Player
@onready var textbox = $Textbox

var area = "none"
var is_fade = false

func _ready() -> void:
	
	if Global.chapter2:
		player.animation = "grusel"
		$EndCutscene.show()
		$Map/Walls/CollisionShape2D2.position.x = 2686.0
		$"Map/könig/CollisionShape2D".disabled = true
	elif Global.kaboom:
		$Map.visible = false
		$"Map/könig/CollisionShape2D".disabled = true
		$RoterWackelpudding.visible = true

	$Map/Soldat.play("default")
	$Map/Soldat2.play("default")
	$Map/Soldat3.play("default")
	$Map/Soldat4.play("default")

func _process(delta: float) -> void:
	if area == "könig" and Input.is_action_just_pressed("Up") and textbox.is_ready() and not Global.kaboom:
		if Global.presentReceived:
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
		call_deferred("change_scene")
func change_scene() -> void:
	var sceneRes = load("res://scenes/wiese.tscn")
	var scene = sceneRes.instantiate()
	get_tree().root.add_child(scene)
	scene.player.position = Vector2(9633.0,696.0)
	queue_free()
func _könig_entered(body: Node2D) -> void:
	if body == player and not Global.kaboom:
		player.interact()
		area = "könig"
func _on_end_triggered(body: Node2D) -> void:
	if body == player and not $Map/Walls/CollisionShape2D3.disabled and not is_fade:
		player.canMove = false
		is_fade = true
		await get_tree().create_timer(1.).timeout
		textbox.addText("Wait.")
		textbox.addText("I can't get out.", func(): 
			await get_tree().create_timer(2.).timeout
			fade()
			textbox.addText("I'm so sorry father")
		)

func fade() -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(
		func(val: float): $Dissolve/ColorRect.material.set_shader_parameter("dissolve_value", val),
		0.0,
		1.0,
		20.0
	)
