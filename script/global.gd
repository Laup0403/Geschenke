extends Node

var username = ""

var presentReceived = false
var kaboom = false
var toiletFree = false
var chapter2 = false

var crt = false
var toCrt = false

func _ready() -> void:
	if OS.has_environment("USERNAME"):
		username = OS.get_environment("USERNAME")
	elif OS.has_environment("USER"):
		username = OS.get_environment("USER")
	
	if username.is_empty() or username.length() > 9:
		username = "Dieter"
