extends Node2D

@onready var player = $Player
@onready var textbox = $UI/Textbox

var area = "none"
var skinnymanSpoken = false

func _ready() -> void:
	
	for anim in $Map.get_children():
		if anim is AnimatedSprite2D:
			anim.play("default")
	
	if Global.chapter2:
		player.animation = "grusel"

func _process(delta: float) -> void:
	if Global.chapter2:
		player.animation = "grusel"
	
	if Input.is_action_just_pressed("Up") and textbox.is_ready():
		match area:
			"klo":
				if Global.chapter2:
					textbox.addText("Don't you have other problems than shitting?")
				elif Global.toiletFree:
					get_tree().quit()
				elif Global.presentReceived:
					textbox.addText("You hear flushing")
				else:
					textbox.addText("It seems like the toilet is clogged")
			"house1":
				var sceneRes = load("res://scenes/house.tscn")
				var scene = sceneRes.instantiate()
				scene.spoken = true
				get_tree().root.add_child(scene)
				scene.player.position = Vector2(7690.0,1181.0)
				queue_free()
			"house2":
				textbox.addText("It's locked")
			"house3":
				get_tree().quit()
			"house4":
				textbox.addText("It's locked")
			"skinnymann":
				if skinnymanSpoken:
					textbox.addText("Isn't it a beautiful day?")
				else:
					textbox.addText("Good morning, "+Global.username)
					skinnymanSpoken = true
			"hund":
				textbox.addText("It's Beate the Dog!")
	
	if Global.presentReceived and not Global.kaboom and player.position.x <= 2404.0:
		Global.kaboom = true
		$Player/Camera2D.screen_shake(200, 2)
		player.canMove = false
		await get_tree().create_timer(2.5).timeout
		textbox.addText("Oh shit")


func _exit(body: Node2D) -> void:
	if body == player:
		player.notInteract()
		area = "none"

func _haus1(body: Node2D) -> void:
	if body == player:
		player.interact()
		area = "house1"
func _haus2(body: Node2D) -> void:
	if body == player:
		player.interact()
		area = "house2"
func _haus3(body: Node2D) -> void:
	if body == player:
		player.interact()
		area = "house3"
func _haus4(body: Node2D) -> void:
	if body == player:
		player.interact()
		area = "house4"
func _klo(body: Node2D) -> void:
	if body == player:
		player.interact()
		area = "klo"
func _skinnymann(body: Node2D) -> void:
	if body == player:
		player.interact()
		area = "skinnymann"
func _hund(body: Node2D) -> void:
	if body == player:
		player.interact()
		area = "hund"

func _schloss(body: Node2D) -> void:
	if body == player:
		call_deferred("enter_schloss")
func enter_schloss() -> void:
	var sceneRes = load("res://scenes/schloss.tscn")
	var scene = sceneRes.instantiate()
	get_tree().root.add_child(scene)
	scene.player.position = Vector2(150.0,437.0)
	queue_free()
