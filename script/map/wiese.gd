extends Node2D

@onready var player = $Player
@onready var textbox = $UI/Textbox

var area = "none"
var skinnymanSpoken = false
var tweenStarted = false

func _ready() -> void:
	if Global.newPlayerPos != Vector2.ZERO:
		player.position = Global.newPlayerPos
		Global.newPlayerPos = Vector2.ZERO
	
	for anim in $Map.get_children():
		if anim is AnimatedSprite2D:
			anim.play("default")
	
	if Global.chapter2:
		player.animation = "grusel"
		$Map/Hund.hide()

func _process(_delta: float) -> void:
	if Global.chapter2:
		player.animation = "grusel"
	
	if Global.ontoilet:
			$Map/Walls/CollisionShape2D5.disabled = false
			if tweenStarted:
				return
			tweenStarted = true
			var tween = get_tree().create_tween()
			tween.tween_method(
				func(val: float): $UI/Dissolve.material.set_shader_parameter("dissolve_value", val),
				0.0,
				1.0,
				15.0
			)
			
			await get_tree().create_timer(4.).timeout
			
			Audio.clear_bg_music(15.0)
			await tween.finished
			SceneLoader.load_scene("uid://dhccf5ct2l0al")
	elif Input.is_action_just_pressed("Up") and textbox.is_ready():
			match area:
				"klo":
					if Global.chapter2:
						textbox.addText("Don't you have other problems than shitting?")
					elif Global.toiletFree:
						Audio.change_bg_music("uid://cumguhr2mejnb", -20)
						Audio.play_sound("uid://dtb0oc5nap8w3")
						SceneLoader.load_scene("uid://be5yaq308u56j")
					elif Global.presentReceived:
						textbox.addText("You hear flushing")
					else:
						textbox.addText("It seems like the toilet is clogged")
				"house1":
					if Global.fatherSpoken:
						textbox.addText("Your father locked the door")
					else:
						Global.newPlayerPos = Vector2(7690.0,1181.0)
						Global.newVariables = "spoken"
						if Global.presentReceived:
							Audio.change_bg_music("uid://6q2qccdabgil", -20)
						else:
							Audio.change_bg_music("uid://cumguhr2mejnb", -20)
						Audio.play_sound("uid://dtb0oc5nap8w3")
						SceneLoader.load_scene("uid://dk3eaxbyosm2i")
				"house2":
					Audio.play_sound("uid://cvllpovu5by2d", 0, true)
					textbox.addText("It's locked")
				"house3":
					if Global.chapter2:
						Global.newVariables = "Key"
						Global.newPlayerPos = Vector2(3010.0,515.0)
						Audio.change_bg_music("uid://cumguhr2mejnb", -20)
						Audio.play_sound("uid://dtb0oc5nap8w3")
						SceneLoader.load_scene("uid://dhccf5ct2l0al")
					elif not Global.fuchsteufelswild:
						Audio.change_bg_music("uid://bxv1y6vk37bgd", -20, 0.1)
						Global.fuchsteufelswild = true
						var anim = $UI/Father/AnimationPlayer
						player.canMove = false
						anim.play("Vadda")
						await anim.animation_finished
						Audio.change_bg_music("uid://0lt7vwi7b6cm", -20, 0.1)
						textbox.addText("You're not supposed to come here.")
						textbox.addText("That makes me fox-devils-mad!", func():
							$UI/Father.hide()
							Audio.change_bg_music("uid://cge8jhi3grnac", -20, 2)
						)
					else:
						textbox.addText("Your father told you not to come here.")
				"house4":
					Audio.play_sound("uid://cvllpovu5by2d", 0, true)
					textbox.addText("It's locked")
				"skinnymann":
					if Global.chapter2:
						textbox.addText("I hope your pillow is warm on both sides!")
						textbox.addText("#######")
					elif skinnymanSpoken:
						textbox.addText("Isn't it a beautiful day?")
					else:
						textbox.addText("Good morning, "+Global.username)
						skinnymanSpoken = true
				"hund":
					if Global.chapter2:
						textbox.addText("Beate is hiding from you")
					else:
						Audio.play_sound("uid://cg38578hiiaa3")
						textbox.addText("It's Beate the Dog!")
				"madl":
					if Global.chapter2:
						textbox.addText("We don't date guys under 1,90m")
					else:
						textbox.addText("Hiii, "+Global.username)
	
	if Global.presentReceived and not Global.kaboom and player.position.x <= 8569.0:
		Global.kaboom = true
		Audio.play_sound("uid://cohqltdaa2m2p", 20.0)
		$Player/Camera2D.screen_shake(200, 4)
		player.canMove = false
		await get_tree().create_timer(4.5).timeout
		textbox.addText("Oh shit", func(): Audio.change_bg_music("uid://cge8jhi3grnac", -20, 4))


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
func _madl(body: Node2D) -> void:
	if body == player:
		player.interact()
		area = "madl"
func _schloss(body: Node2D) -> void:
	if body == player:
		Global.newPlayerPos = Vector2(150.0,437.0)
		if not Global.fatherSpoken:
			Audio.change_bg_music("uid://cumguhr2mejnb", -20)
		else:
			Audio.beeb()
		SceneLoader.load_scene("uid://ukgo53hblnhu")

func _stronger_crt(body: Node2D) -> void:
	if body == player and Global.fatherSpoken and not Global.strongerCrt:
		
		player.canMove = false
		player.canAnim = false
		player.anim.play("ogottogott")
		
		await get_tree().create_timer(3).timeout
		
		Global.strongerCrt = true
		
		await get_tree().create_timer(1).timeout
		
		textbox.addText("Must...")
		textbox.addText("... Castle")
		textbox.addText("qwocnyxlnwqm...", func():
			player.canAnim = true
		)
