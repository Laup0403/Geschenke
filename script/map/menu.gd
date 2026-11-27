extends Node2D

func _start() -> void:
	Global.presentReceived = false
	Global.kaboom = false
	Global.toiletFree = false
	Global.chapter2 = false
	Global.fuchsteufelswild = false
	Global.ontoilet = false
	Global.fatherSpoken = false
	Global.crt = false
	Global.strongerCrt = false
	Global.toCrt = false
	
	SceneLoader.load_scene("uid://n63y4nhkr0fl")

func _quit() -> void:
	get_tree().quit()
