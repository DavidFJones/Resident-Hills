extends Control

func pause_game(pause_state):
	$PauseUI.visible = pause_state

func _ready():
	GameManager.inventoryUI = get_child(0)

func _on_quit_button_pressed():
	GameManager.UIManager.quit_game()

func _on_reload_button_pressed():
	GameManager.UIManager.reload_scene()

func _on_http_refresh_button_pressed():
	GameManager.refresh_http()
