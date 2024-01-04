extends Node

func quit_game():
	get_tree().quit()

func reload_scene():
	GameManager.input_Pause()
	get_tree().reload_current_scene()
	GameManager.loaded = false
