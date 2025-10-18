# sound_manager.gd
extends Node

var bgm_player: AudioStreamPlayer
var ui_player: AudioStreamPlayer


func ensure_players_exist():
	# Check for bgm_player
	if not is_instance_valid(bgm_player):
		bgm_player = AudioStreamPlayer.new()
		add_child(bgm_player) 
		# Use call_deferred to set the bus on the next frame
		# This guarantees the node is in the tree and can find the "Music" bus.
		bgm_player.call_deferred("set_bus", "Music")

	# Check for ui_player
	if not is_instance_valid(ui_player):
		ui_player = AudioStreamPlayer.new()
		add_child(ui_player)
		# Use call_deferred for the SFX bus as well
		ui_player.call_deferred("set_bus", "SFX")


func play_bgm(music_stream: AudioStream):
	ensure_players_exist() 
	bgm_player.stream = music_stream
	bgm_player.play()


func play_ui_sound(sound_stream: AudioStream):
	ensure_players_exist()
	ui_player.stream = sound_stream
	ui_player.play()
