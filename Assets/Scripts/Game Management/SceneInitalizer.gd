extends Node

# literally all this does is call back to the GameManager and fire the actual initalization function
func _ready():
	GameManager.initialize_scene(self)
