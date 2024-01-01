extends Control

#array to hold all our items, initalize this array with 9 null entries
var inventoryArray := [null,null,null,null,null,null,null,null,null]

#reference to our title and description text elements
var titleText;
var descText;

#reference to the itemgrid that holds 3 item buttons
var itemGrid

func _ready():
	titleText = $Panel/ItemName
	descText = $Panel/ItemDesc
	itemGrid = $Panel/ItemGrid

func _process(delta):
	if Input.is_action_just_pressed("debug_print_inventory"):
		for item in inventoryArray:
			if item != null:
				print(item.Name)
			else:
				print(null)

func _on_inventory_button_pressed(index):
	print("Pressed - ",index,"  ",inventoryArray[index])

func pickup_item(newItem):
	#stores the first empty slot in array
	var emptySlot = null
	
	#loop through the array of inventory slots
	var items = inventoryArray
	for i in inventoryArray.size():
		var item = items[i]
		#if the slot is empty, and we have not yet identified an empty slot, save a reference to the index
		if items[i] == null and emptySlot == null:
			emptySlot = i

	#checks if we should ad the item to the inventory
	if emptySlot != null:
		inventoryArray[emptySlot] = newItem.CustomItem
		#replace the icon for the button with the items icon
		print(itemGrid.get_child(emptySlot).icon)
		itemGrid.get_child(emptySlot).icon = inventoryArray[emptySlot].Img
		newItem.queue_free()
	#find stackable item with available space

func _on_item_focus_entered(slotID):
	#if we are hovering over an inventory slot with an item, change the name and description text on the ui
	if inventoryArray[slotID] != null:
		titleText.text = "[center]" + inventoryArray[slotID].Name + "[/center]"
		descText.text = inventoryArray[slotID].Description
	else:
		titleText.text = ""
		descText.text = ""
