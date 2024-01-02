extends Control

## The default icon used for an empty inventory slot
@export var defaultInventoryIcon : CompressedTexture2D

#array to hold all our items, initalize this array with 9 null entries
var inventoryArray := [null,null,null,null,null,null,null,null,null]

#reference to our title and description text elements
var titleText;
var descText;
#reference to the itemgrid that holds 3 item buttons
var itemGrid
#reference to our popup menu, shows all the available options for a given item
var popupOptions

## Offset for how far up and left the popup options menu appears next to its relivant button
@export var popupOffset : Vector2

#a variable to store the currently selected item index. used for pressing the popup menu buttons 
var currentWorkingIndex

#a bool to determine if we are moving an object. Used to control state across multiple functions
var movingItem : bool = false
#a bool for seeing if we canceled our move early
var moveCancelledEarly : bool = false
#a reference to our icon that we wish to have follow the mouse position when moving an item
var movingIcon

func _ready():
	titleText = $Panel/ItemName
	descText = $Panel/ItemDesc
	itemGrid = $Panel/ItemGrid
	popupOptions = $Panel/PopupOptions
	movingIcon = $MovingIcon

func _process(delta):
	if moveCancelledEarly and not movingItem:
		force_reset_ui_elements()

	if not movingItem:
		return

	movingIcon.set_position(get_global_mouse_position())

func toggle_inventory_open(value):
	self.visible = value
	#the options popup can always start disabled as it should only be visible after a player has pressed a ui option
	popupOptions.visible = false

	#force stop our move state in case we have not moved an item yet
	movingItem = false	

func enable_visible_options(index):
	#loop through all the options and disable their visibility
	#with the exception of move and cancel, as these options should be on ever item at all times
	#currently the Examine option is unused, and will never be visible/accesible
	for button in popupOptions.get_children():
		if button == $Panel/PopupOptions/Button_Move or button == $Panel/PopupOptions/Button_Cancel:
			continue

		button.visible = false

	#ugly hardcoded way of checking for relevant settings on an object and enabling coresponding buttons
	
	#Also set the text of the button
	if inventoryArray[index].Equipable:
		$Panel/PopupOptions/Button_Equip.visible = true
		if inventoryArray[index].IsEquipped:
			$Panel/PopupOptions/Button_Equip.text = "Unequip"
		else:
			$Panel/PopupOptions/Button_Equip.text = "Equip"

	if inventoryArray[index].CanCombine:
		$Panel/PopupOptions/Button_Combine.visible = true

	if inventoryArray[index].CanCombine:
		$Panel/PopupOptions/Button_Combine.visible = true

	#hasbeenused means that this key item has finished being relevant and may also be dropped
	if inventoryArray[index].CanDrop or inventoryArray[index].HasBeenUsed:
		$Panel/PopupOptions/Button_Drop.visible = true

func _on_inventory_button_pressed(index):
	#this only runs if we have started moving an item, as this changes the context of what we want to do
	if movingItem:
		var movedItemReference = inventoryArray[currentWorkingIndex]
		var newItemReference = inventoryArray[index]
		
		#the current working index should get the clicked/new item
		inventoryArray[currentWorkingIndex] = newItemReference
		#the new index should get the currenlty moving item
		inventoryArray[index] = movedItemReference
		#the current working index button should get the clicked item icon, if it is null set it to default texture
		if newItemReference == null:
			itemGrid.get_child(currentWorkingIndex).icon = defaultInventoryIcon
		else:
			itemGrid.get_child(currentWorkingIndex).icon = newItemReference.Img
		#change the equip and ammo count from the old button icon
		set_equip_UI(currentWorkingIndex)
		set_ammo_count_UI(currentWorkingIndex)
		#the new button "index" should get the moved item icon
		itemGrid.get_child(index).icon = movedItemReference.Img
		#Set ammo and equiped ui on new item
		set_equip_UI(index)
		set_ammo_count_UI(index)

		#stop the moving item state
		movingItem = false
		#remove the cancelled bool, as we have "properly" ended the moving state
		moveCancelledEarly = false
		#hide the moving icon
		movingIcon.visible = false
		#end this nonsense
		return
	
	#check to see if there is even an item in the selected slot
	if inventoryArray[index] == null:
		#close the popup menu
		popupOptions.visible = false
		return

	#function used to determine which menu options should be available based on the selected item
	enable_visible_options(index)
	#make our options menu visible
	popupOptions.visible = true
	#set the position of our options menu relative to the button that was pressed, plus a manual offset value
	popupOptions.position = itemGrid.position + itemGrid.get_child(index).position + popupOffset
	#set our working index to match the index of the item/button selected
	currentWorkingIndex = index

func set_ammo_count_UI(index):
	if inventoryArray[index] == null:
		itemGrid.get_child(index).get_child(1).visible = false
		return

	if inventoryArray[index].MaxAmmo > 0:
			#show the ammo count
			#really lazy way of grabbing this node, fix this later on
			itemGrid.get_child(index).get_child(1).text = str(inventoryArray[index].CurrentAmmo)
			itemGrid.get_child(index).get_child(1).visible = true

func set_equip_UI(index):
	if inventoryArray[index] == null:
		itemGrid.get_child(index).get_child(0).visible = false
		return
		
	print(inventoryArray[index])
	if inventoryArray[index].IsEquipped:
		itemGrid.get_child(index).get_child(0).visible = true
	else:
		itemGrid.get_child(index).get_child(0).visible = false

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
		itemGrid.get_child(emptySlot).icon = inventoryArray[emptySlot].Img
		#initalize the current ammo to equal starting ammo if that is relevant
		#Also toggel the ammo counter on the bottom right of the button
		if inventoryArray[emptySlot].MaxAmmo > 0:
			#set the ammo value
			inventoryArray[emptySlot].CurrentAmmo = inventoryArray[emptySlot].StartingAmmo
			#show the ammo count
			set_ammo_count_UI(emptySlot)
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

func _on_button_cancel_pressed():
	popupOptions.visible = false

func _on_button_equip_pressed():
	#check if we are unequipping an equipped item
	if inventoryArray[currentWorkingIndex].IsEquipped:
		inventoryArray[currentWorkingIndex].IsEquipped = false
		#hide the equipped inventory icon
		itemGrid.get_child(currentWorkingIndex).get_child(0).visible = false
		#close the popup menu
		popupOptions.visible = false
		return

	#loop through all our other buttons and make sure the equipped icon is not selected
	#also make sure none of our items are equipped
	for i in inventoryArray.size():
		itemGrid.get_child(i).get_child(0).visible = false
		if inventoryArray[i] != null:
			inventoryArray[i].IsEquipped = false

	#set the correct item to show the equipped icon
	itemGrid.get_child(currentWorkingIndex).get_child(0).visible = true

	#set the items equipped propety to true
	inventoryArray[currentWorkingIndex].IsEquipped = true

	#close the popup menu
	popupOptions.visible = false

func _on_button_drop_pressed():
	#remove the item from our item array
	inventoryArray[currentWorkingIndex] = null

	#reset the button icon to the empty default
	itemGrid.get_child(currentWorkingIndex).icon = defaultInventoryIcon

	#hide ammo and equip icons from button
	itemGrid.get_child(currentWorkingIndex).get_child(0).visible = false
	itemGrid.get_child(currentWorkingIndex).get_child(1).visible = false

	#reset text and description fields
	titleText.text = ""
	descText.text = ""

	#close the popup menu
	popupOptions.visible = false

func _on_button_move_button_down():
	#reset the button icon to the empty default
	itemGrid.get_child(currentWorkingIndex).icon = defaultInventoryIcon

	#set our bool state, affects things in the process method and other places
	movingItem = true
	#set our bool to check if we are cancelling early
	moveCancelledEarly = true

	#make out moving texture that will follow the mouse visible
	movingIcon.visible = true
	#set the icon to match the icon from the item the player wishes to move
	movingIcon.texture = inventoryArray[currentWorkingIndex].Img

	#close the popup menu
	popupOptions.visible = false

func force_reset_ui_elements():
	moveCancelledEarly = false
	#loop through our items and reset each element
	for i in inventoryArray.size():
		if inventoryArray[i] == null:
			continue
		#Reset each element
		itemGrid.get_child(i).icon = inventoryArray[i].Img
		set_ammo_count_UI(i)
		set_equip_UI(i)

	#hide the moving icon
	movingIcon.visible = false
