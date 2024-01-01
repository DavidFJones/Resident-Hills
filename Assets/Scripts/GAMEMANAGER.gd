extends Node

#bool for pause state
var paused := false

#reference to our pause screen
var pauseUINode

func _ready():
	pauseUINode = $PauseUI

func toggle_pause():
	paused = !paused
	get_tree().paused = paused
	pauseUINode.visible = paused

func _process(delta):
	if Input.is_action_just_pressed("input_Pause"):
		toggle_pause()


func _on_quit_button_pressed():
	get_tree().quit()
