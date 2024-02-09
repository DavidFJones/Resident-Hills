extends Node

#bool for pause state
var paused := false

#References to children ----
var UIManager

#Managemenet Nodes ------
#handles loading item content for http requests
var itemHttp = preload("res://Nodes/Game Management/itemHTTP.tscn")
var itemHttpInstance
#Player UI
var gameUI = preload("res://Nodes/Game Management/game_ui.tscn")
var gameUIInstance
var inventoryUI
#ugly way of seeing if we have loaded the scene or not
var loaded = false

#holds all our collectables in the scene
var allItems = []

#Game Inputs -----------------
func input_Pause():
	paused = !paused
	get_tree().paused = paused
	gameUIInstance.pause_game(paused)
# ----------------------------

func _ready():
	UIManager = $UIManager

func register_new_item(item):
	allItems.append(item)

func _process(_delta):
	if Input.is_action_just_pressed("input_Pause"):
		input_Pause()

	#real ugly way of confirming if the scene is loaded before creating the spawn initalizer
	if loaded:
		pass
	else:
		if get_tree().root.get_child(1) != null:
			initialize_scene()
			loaded = true

func initialize_scene():
	var root_parent = get_tree().root.get_child(1)
	#create instances for our managers/elements
	itemHttpInstance = itemHttp.instantiate()
	gameUIInstance = gameUI.instantiate()
	#add our managers/elements to the scene
	root_parent.add_child(gameUIInstance)
	root_parent.add_child(itemHttpInstance)
	#update all our items via web spreadsheet
	itemHttpInstance.make_HTTP_item_request(allItems)

func refresh_http():
	itemHttpInstance.make_HTTP_item_request(allItems);
