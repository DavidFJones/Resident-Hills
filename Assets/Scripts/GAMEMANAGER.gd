extends Node

#bool for pause state
var paused := false

#References -------
#UI Elements
#Pause Screen
var pauseUI
#Inventory Screen
var inventoryUI

func _ready():
	pauseUI = $GameUI/PauseUI
	inventoryUI = $GameUI/PlayerInventory

func toggle_pause():
	paused = !paused
	get_tree().paused = paused
	pauseUI.visible = paused

func _process(delta):
	if Input.is_action_just_pressed("input_Pause"):
		toggle_pause()


func _on_quit_button_pressed():
	get_tree().quit()
