extends CanvasLayer

@onready var text = $MarginContainer/Label
@export var player: CharacterBody2D

var textQueue = []
var state = "ready"
var index = 0
var timer = 0
var entry

var reading_speed = 0.10

func _ready() -> void:
	text.hide()

func showNextText():
	entry = textQueue.pop_front()
	text.text = entry.text
	text.visible_characters = 0
	text.show()
	if player != null:
		player.canMove = false
	timer = 0
	index = 0
	state = "reading"

func _process(delta: float) -> void:
	
	# show textbox if text
	if state == "ready" && !textQueue.is_empty():
		text.show()
		if player != null:
			player.canMove = false
		showNextText()
		state = "reading"
		return
	
	# Hide textbox if no text
	elif state == "ready" && textQueue.is_empty():
		if text.visible:
			if player != null:
				player.canMove = true
			text.hide()
	
	# Reading the text
	if index < len(text.text) && state == "reading":
		
		if timer <= 0:
			timer = reading_speed
			
			index += 1
		else:
			timer -= delta
		
		text.visible_characters = index
	
	# set state to finished
	elif index >= len(text.text) && state == "reading":
		state = "finished"
		text.visible_characters = -1
	
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
