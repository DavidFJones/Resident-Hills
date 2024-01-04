extends Control

func pause_game(pause_state):
	$PauseUI.visible = pause_state

func _on_quit_button_pressed():
	GameManager.UIManager.quit_game()

func _on_reload_button_pressed():
	GameManager.UIManager.reload_scene()
