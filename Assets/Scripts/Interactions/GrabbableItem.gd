extends StaticBody3D

@export var CustomItem : CustomItems

signal interact_item(item)

func interaction():
	interact_item.emit(self,"itemPickup")
