extends Node

var player: AudioStreamPlayer
var sfx: AudioStreamPlayer
var piep: AudioStreamPlayer
var tween: Tween

func _ready() -> void:
	player = AudioStreamPlayer.new()
	add_child(player)
	
	sfx = AudioStreamPlayer.new()
	add_child(sfx)
	
	piep = AudioStreamPlayer.new()
	piep.stream = load("uid://t1wjj47o71be")
	piep.volume_db = -30.0
	add_child(piep)

func change_bg_music(new_path: String, volume: float = 0.0, fade_duration: float = 3) -> void:
	
	# neuen stream laden
	var new_stream: AudioStream = load(new_path)
	
	# Wenn der schon läuft return
	if player.stream == new_stream and player.playing:
		return

	# Wenn fade und nochmal fade, abbrechen
	if tween and tween.is_running():
		tween.kill()

	var half_duration := fade_duration / 2.0
	tween = create_tween()

	# Nur ausfaden wenn musik schon spielt
	if player.playing:
		tween.tween_property(player, "volume_db", -80.0, half_duration).set_trans(Tween.TRANS_SINE)
	else:
		player.volume_db = -80.0

	# Stream tauschen und spielen
	tween.tween_callback(func():
		player.stream = new_stream
		player.volume_db = volume
		player.play()
	)

	# Einfaden
	tween.tween_property(player, "volume_db", volume, half_duration).set_trans(Tween.TRANS_SINE)

func clear_bg_music(fade_duration: float = 2.5) -> void:
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween()
	
	if player.playing:
		tween.tween_property(player, "volume_db", -80.0, fade_duration).set_trans(Tween.TRANS_SINE)
	else:
		player.volume_db = -80.0
	
	await tween.finished
	
	player.stop()

func get_bg_muic() -> String:
	return player.stream.to_string()

func play_sound(path: String, volume: float = 0.0, overwrite: bool = false) -> void:
	var new_stream = load(path)
	
	if sfx.playing:
		if overwrite:
			sfx.stop()
		else:
			return
	
	sfx.stream = new_stream
	sfx.volume_db = volume
	
	sfx.play(0.0)

func beeb() -> void:
	if piep.playing:
		piep.playing = false
	else:
		piep.playing = true
