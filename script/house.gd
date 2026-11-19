extends Node2D

@onready var player = $Player
@onready var textbox = $UI/Textbox
@onready var doorcam = $Cameras/Door
@onready var bedcam = $Cameras/Bed
@onready var cam = $Cameras/Vadder

var newPos: Vector2

var area = "none"
var spoken = false
var atomSpaltung = false
var inBedroom = false

func _ready() -> void:
	if newPos:
		player.position = newPos
	$Map/Vater/Vater.play("default")
	
	if Global.chapter2:
		player.position = Vector2(2378.0,1181.0)
		player.animation = "grusel"
		textbox.addText("Son.")
		textbox.addText("You kill your self?")
		textbox.addText("You can't kill your problems!")
		textbox.addText("You are  a disgrace to our familiy!")
	elif Global.presentReceived:
		$Map/Vater/CollisionShape2D.disabled = true
		$Map/Vater/Vater.visible = false

func _process(delta: float) -> void:
	if $UI/Geschenk.visible:
		$UI/Geschenk/Rahmen.rotate(0.005)
	
	change_camera()
	
	check_areas()
	
	atom_spalten(delta)

func change_camera() -> void:
	if player.position.x > 3669.0:
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

func check_areas() -> void:
	if Input.is_action_just_pressed("Up") and textbox.is_ready():
		match area:
			"exit":
				if spoken or Global.chapter2:
					var sceneRes = load("res://scenes/wiese.tscn")
					var scene = sceneRes.instantiate()
					get_tree().root.add_child(scene)
					scene.player.position = Vector2(2993.0,798.0)
					queue_free()
				else:
					textbox.addText("Talk to your father first.")
			"bed":
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

func atom_spalten(delta) -> void:
	if Global.presentReceived and not Global.chapter2:
		if atomSpaltung:
			player.canMove = false
			var tree = get_tree()
			
			await tree.create_timer(2).timeout
			$Map/Gruselmann.show()
			var camera = $Cameras/Vadder
			
			while camera.offset.x <= 1600:
				camera.offset.x += 0.1
				await tree.process_frame
			
			await tree.create_timer(2).timeout
			$Player/Boom.show()
			
			await tree.create_timer(0.1).timeout
			tree.change_scene_to_file("res://scenes/free.tscn")
			
		elif $Cameras/Bed.enabled and not inBedroom and $Map/Vater/CollisionShape2D.disabled:
			inBedroom = true
			await get_tree().create_timer(1.0).timeout
			textbox.addText("It seems like no one is here") 
			$Map/Vater/CollisionShape2D.disabled = false
			$Map/Vater/Vater.visible = true
		elif not $Cameras/Bed.enabled:
			inBedroom = false



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
