extends Node2D

@onready var player = $Player
@onready var textbox = $UI/Textbox

var area = "none"
var key = false

func _ready() -> void:
	player.animation = "grusel"
	if Global.newPlayerPos != Vector2.ZERO:
		player.position = Global.newPlayerPos
		Global.newPlayerPos = Vector2.ZERO
	if Global.newVariables == "Key":
		key = true
		$Map/Drugs/Key.hide()
	
	Global.chapter2 = "true"
	if not Global.crt:
		player.canMove = false
		$UI/Black.show()
		$UI/Eyes.show()
	
		await get_tree().create_timer(4).timeout
	
		Audio.change_bg_music("uid://k2kc0b4xcwsa", -20.0, 5.0)
		$UI/Eyes/Open.show()
	
		await get_tree().create_timer(2).timeout
	
		$UI/Eyes.hide()
		$UI/Black.hide()
	
		await get_tree().create_timer(1.5).timeout
	
		textbox.addText("I can't take this anymore")
		textbox.addText("These dreams are getting worse")

func _process(_delta: float) -> void:
	change_camera()
	
	if textbox.is_ready() and Input.is_action_just_pressed("Up"):
		match area:
			"sink":
				textbox.addText("You wonder what's behind the curtain")
			"photo":
				textbox.addText("It looks like drawn by a child")
			"key":
				if key:
					textbox.addText("Why are they here?")
				else:
					textbox.addText("Between the pills, there is a key")
					textbox.addText("You take it", func():
						key = true
						Audio.play_sound("uid://weoc6jtfdj68",0,true)
						$Map/Drugs/Key.hide()
					)
			"door":
				if key:
					Global.presentReceived = false
					Global.kaboom = false
					Global.chapter2 = true
					Global.ontoilet = false
					Global.newPlayerPos = Vector2(5793.0,798.0)
					var bus := AudioServer.get_bus_index("Master")
					AudioServer.set_bus_effect_enabled(bus, 0, true)
					AudioServer.set_bus_effect_enabled(bus, 1, true)
					AudioServer.set_bus_effect_enabled(bus, 2, true)
					Audio.change_bg_music("uid://cge8jhi3grnac", -20)
					Audio.play_sound("uid://dtb0oc5nap8w3")
					SceneLoader.load_scene("uid://khnvv4e0ipum")
				else:
					textbox.addText("It's locked")

func change_camera() -> void:
	if player.position.x > 2365.0:
		$Cameras/AndererRaum.enabled = false
		$Cameras/Door.enabled = true
		$Cameras/Bedroom.enabled = false
	elif player.position.x < 1217.0:
		$Cameras/AndererRaum.enabled = false
		$Cameras/Door.enabled = false
		$Cameras/Bedroom.enabled = true
	else:
		$Cameras/AndererRaum.enabled = true
		$Cameras/Door.enabled = false
		$Cameras/Bedroom.enabled = false

func _exit(body: Node2D) -> void:
	if body == player:
		player.notInteract()
		area = "none"
func _crt(body: Node2D) -> void:
	if not Global.crt and body == player:
		player.canMove = false
		await get_tree().create_timer(1).timeout
		Audio.beeb()
		player.canAnim = false
		player.get_node("AnimatedSprite2D").play("ogottogott")
		Global.toCrt = true
		await get_tree().create_timer($UI/Crt.CHANGE_TIME + 1).timeout
		player.canMove = true
		player.canAnim = true
		Audio.beeb()
func _sink(body: Node2D) -> void:
	if body == player:
		player.interact()
		area = "sink"
func _photo(body: Node2D) -> void:
	if body == player:
		player.interact()
		area = "photo"
func _door(body: Node2D) -> void:
	if body == player:
		player.interact()
		area = "door"
func _key(body: Node2D) -> void:
	if body == player:
		player.interact()
		area = "key"
