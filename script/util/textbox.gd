extends CanvasLayer

@onready var textbox = $MarginContainer/Label
@export var player: CharacterBody2D

var textQueue = []
var state = "ready"
var index = 0
var timer = 0
var entry

var reading_speed = 0.10

func _ready() -> void:
	textbox.hide()

func showNextText():
	entry = textQueue.pop_front()
	textbox.text = entry.text
	textbox.visible_characters = 0
	textbox.show()
	if player != null:
		player.canMove = false
	timer = 0
	index = 0
	state = "reading"

func _process(delta: float) -> void:
	
	# show textbox if text
	if state == "ready" && !textQueue.is_empty():
		textbox.show()
		if player != null:
			player.canMove = false
		showNextText()
		state = "reading"
		Audio.play_sound("uid://2cd4xr1twr08")
		return
	
	# Hide textbox if no text
	elif state == "ready" && textQueue.is_empty():
		if textbox.visible:
			if player != null:
				player.canMove = true
			Audio.play_sound("uid://2cd4xr1twr08")
			textbox.hide()
	
	# Reading the text
	if index < len(textbox.text) && state == "reading":
		
		if timer <= 0:
			timer = reading_speed
			
			index += 1
		else:
			timer -= delta
		
		textbox.visible_characters = index
	
	# set state to finished
	elif index >= len(textbox.text) && state == "reading":
		state = "finished"
		textbox.visible_characters = -1
	
## User Input ##
	reading_speed = 0.10
	if state == "reading" && Input.is_action_pressed("Everything"):
		reading_speed = 0.03
	
	if state == "finished" && Input.is_action_just_pressed("Everything"):
		if entry.afterCall:
			entry.afterCall.call()
		state = "ready"

## Input Functions ##

func addText(text:String,afterCall:Callable=Callable()):
	textQueue.push_back({
		"text": "* "+text+" *",
		"afterCall": afterCall
	})

func clear():
	textQueue = []

func is_ready() -> bool:
	if state == "ready": return true 
	else: return false
