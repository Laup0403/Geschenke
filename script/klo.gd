extends Node2D

var area = "none"

func _ready() -> void:
	$Player.canMove = false
	await get_tree().create_timer(1.0).timeout
	$Textbox.addText("Bro here is nothing")

func _process(delta: float) -> void:
	if area != "none" and Input.is_action_just_pressed("Up"):
		get_tree().change_scene_to_file("res://scenes/house_2.tscn")

func _on_exit(body: Node2D) -> void:
	if body == $Player:
		$Player.interact()
		area = "exit"
func _not_exit(body: Node2D) -> void:
	if body == $Player:
		$Player.notInteract()
		area = "none"
