extends Node2D

@onready var player = $Player
@onready var textbox = $UI/Textbox
@onready var doorcam = $Cameras/Door
@onready var bedcam = $Cameras/Bed
@onready var cam = $Cameras/Vadder

var area = "none"
var spoken = false
var atomSpaltung = false
var atomSpaltungRunning = false
var inBedroom = false

func _ready() -> void:
	if Global.newPlayerPos != Vector2.ZERO:
		player.position = Global.newPlayerPos
		Global.newPlayerPos = Vector2.ZERO
	if Global.newVariables == "spoken":
		spoken = true
	
	$Map/Vater/Vater.play("default")
	
	if Global.chapter2:
		player.animation = "grusel"
		$Map/Vater.position.x = 844.0
		$EpicShooting/Player.play("default")
		$EpicShooting/Player.show()
	elif Global.presentReceived:
		$Map/Vater/CollisionShape2D.disabled = true
		$Map/Vater/Vater.visible = false
		$Map/LiterallyNothing.show()

func _process(delta: float) -> void:
	if $UI/Geschenk.visible:
		$UI/Geschenk/Rahmen.rotate(0.005)
	
	change_camera(delta)
	
	check_areas()
	
	atom_spalten()
	

func change_camera(delta) -> void:
	if $Cameras/Move.enabled:
		return
	elif player.position.x > 3669.0:
		cam.enabled = false
		doorcam.enabled = true
		bedcam.enabled = false
	elif player.position.x < -2104.0:
		cam.enabled = false 
		doorcam.enabled = false
		bedcam.enabled = true
	else:
		cam.enabled = true
		doorcam.enabled = false
		bedcam.enabled = false
	
	if Global.chapter2:
		$Cameras/Door.screen_shake(50.0, delta)
		$Cameras/Vadder.screen_shake(50.0, delta)
		$Cameras/Bed.screen_shake(50.0, delta)

func check_areas() -> void:
	if Input.is_action_just_pressed("Up") and textbox.is_ready():
		match area:
			"exit":
				if spoken or Global.chapter2:
					Global.newPlayerPos = Vector2(2993.0,798.0)
					Audio.change_bg_music("uid://cge8jhi3grnac", -20)
					Audio.play_sound("uid://dtb0oc5nap8w3")
					SceneLoader.load_scene("uid://khnvv4e0ipum")
				else:
					textbox.addText("Talk to your father first.")
			"bed":
				if Global.chapter2:
					textbox.addText("That's not even your bed")
				elif Global.presentReceived:
					textbox.addText("It's another present")
					textbox.addText("You remember your father stores\nhundreds of them in the BASEMENT")
				else:
					textbox.addText("You just woke up.")
			"vater":
				if Global.chapter2:
					textbox.addText("Don't you ever dare to come back to me again!")
				elif Global.presentReceived:
					atomSpaltung = true
				elif spoken:
					textbox.addText("What are you waiting for?")
				else:
					textbox.addText("Yo, son.", func(): $UI/Geschenk.show())
					textbox.addText("Could you please bring this present to the king?", func(): $UI/Geschenk.hide())
					textbox.addText("And do NOT go to the purple house!", func(): $UI/Geschenk.hide())
					spoken = true

func atom_spalten() -> void:
	if Global.presentReceived and not Global.chapter2:
		if atomSpaltung and not atomSpaltungRunning:
			atomSpaltungRunning = true
			player.canMove = false
			var tree = get_tree()
			
			Audio.clear_bg_music(4)
			
			await tree.create_timer(4).timeout
			$Map/Gruselmann.show()
			
			var camera = $Cameras/Move
			camera.enabled = true
			cam.enabled = false
			
			Audio.change_bg_music("uid://dw7kvg2d81hs8",-30,0.1)
			
			while camera.offset.x <= 1600:
				camera.offset.x += 10
				await tree.process_frame
			
			await tree.create_timer(2).timeout
			$Player/Boom.show()
			Audio.play_sound("uid://ddvfsc3c86u01", -10, true)
			
			await tree.create_timer(0.1).timeout
			
			Audio.clear_bg_music(2)
			SceneLoader.load_scene("uid://jc8asmc4dblm")



func _any_exited(body: Node2D) -> void:
	if body == player:
		player.notInteract()
		area = "none"
func _exit_entered(body: Node2D) -> void:
	if body == player:
		player.interact()
		area = "exit"
func _bed_entered(body: Node2D) -> void:
	if body == player:
		player.interact()
		area = "bed"
func _vater_entered(body: Node2D) -> void:
	if body == player:
		player.interact()
		area = "vater"
func _nothing(body: Node2D) -> void:
	if not inBedroom and Global.presentReceived and not Global.chapter2 and body == player:
		call_deferred("showVadder")
func showVadder() -> void:
	inBedroom = true
	textbox.addText("It seems like no one is here") 
	$Map/Vater/CollisionShape2D.disabled = false
	$Map/Vater/Vater.visible = true


func _start_schiesserei(body: Node2D) -> void:
	if body == player and not Global.fatherSpoken and Global.chapter2:
		
		var tree = get_tree()
		var camera = $Cameras/Move
		camera.position = Vector2(6580.0,332.0)
		camera.enabled = true
		doorcam.enabled = false
		
		player.canMove = false
		player.canAnim = false
		player.anim.play("grusel_idle")
		player.anim.flip_h = false
		
		await tree.create_timer(3.0).timeout
		
		while camera.offset.x >= -3000:
			camera.offset.x -= 10
			await tree.process_frame
		
		await tree.create_timer(3.0).timeout
		
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 2, false)
		player.anim.play("waffe")
		player.anim.flip_h = true
		
		await tree.create_timer(2.0).timeout
		
		$EpicShooting/Player/Boom.show()
		Audio.play_sound("uid://ddvfsc3c86u01", -10, true)
		
		while $EpicShooting/Player.position.x >= -2000.0:
			$EpicShooting/Player.position.x -= 100
			await tree.process_frame
		
		await tree.create_timer(3.0).timeout
		
		$EpicShooting/Player.hide()
		player.canAnim = true
		
		await tree.create_timer(2.0).timeout
		
		textbox.addText("Son.")
		textbox.addText("What is wrong with you?")
		textbox.addText("First your mother and now your brother!?")
		textbox.addText("You are a disgrace to our familiy!", func():
			Global.fatherSpoken = true
			camera.enabled = false
		)
