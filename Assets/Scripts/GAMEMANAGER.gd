extends Node

#bool for pause state
var paused := false

#References to children ----
var UIManager

#Managemenet Nodes ------
#Makes other calls to the scene manager when it is _ready() (basically an easy way to call an init
#function anytime a new scene is loaded
var sceneInitalizer = preload("res://Nodes/Game Management/scene_initalizer.tscn")
#handles loading item content for http requests
var itemHttp = preload("res://Nodes/Game Management/itemHTTP.tscn")
#Player UI
var gameUI = preload("res://Nodes/Game Management/game_ui.tscn")
var gameUIInstance

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

func _process(delta):
	if Input.is_action_just_pressed("input_Pause"):
		input_Pause()

	#real ugly way of confirming if the scene is loaded before creating the spawn initalizer
	if loaded:
		return
	else:
		if get_tree().root.get_child(1) != null:
			spawn_scene_initalizer()
			loaded = true

func spawn_scene_initalizer():
	var scene = get_tree().root.get_child(1)
	var instance = sceneInitalizer.instantiate()
	scene.add_child(instance)

func initialize_scene(root_parent):
	#create instances for our managers/elements
	var itemHttpInstance = itemHttp.instantiate()
	gameUIInstance = gameUI.instantiate()
	#add our managers/elements to the scene
	root_parent.add_child(gameUIInstance)
	root_parent.add_child(itemHttpInstance)
	#update all our items via web spreadsheet
	itemHttpInstance.make_HTTP_item_request(allItems)
