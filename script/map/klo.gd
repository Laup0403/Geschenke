extends Node2D

var area = "none"

func _ready() -> void:
	if Global.newPlayerPos != Vector2.ZERO:
		$Player.position = Global.newPlayerPos
		Global.newPlayerPos = Vector2.ZERO
	$Player.canMove = false
	await get_tree().create_timer(1.0).timeout
	$Textbox.addText("Bro here is literally nothing")
	Global.ontoilet = true

func _process(_delta: float) -> void:
	if area != "none" and Input.is_action_just_pressed("Up"):
		Global.newPlayerPos = Vector2(2140.0,792.0)
		Audio.change_bg_music("uid://cge8jhi3grnac", -20)
		Audio.play_sound("uid://dtb0oc5nap8w3")
		SceneLoader.load_scene("uid://khnvv4e0ipum")

func _on_exit(body: Node2D) -> void:
	if body == $Player:
		$Player.interact()
		area = "exit"
func _not_exit(body: Node2D) -> void:
	if body == $Player:
		$Player.notInteract()
		area = "none"
