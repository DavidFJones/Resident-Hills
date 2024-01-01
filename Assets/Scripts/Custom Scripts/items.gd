extends Resource
class_name CustomItems

## The unique id of this item. Used to grab the following data from an external data source
@export var ID : int = 0
@export var Name : String = "Name"
@export var Description : String = "Description"
@export var Img : CompressedTexture2D
## Used to determine the "most important" item the player should interact with if multiple items are overlapping
@export var Priority := 1
## Used to see if this item should stack in the inventory
@export var Stackable : bool = false
## What is the total amount for a stack of this item
@export var StackCount : int = 0
## How many counts of the item should this specific instance of the item conatain? (IE: should this ammo box start with 5 rounds)
@export var StartingStackCount : int = 0
## Is this item equipable? Used later on by the inventory system to handle equip interactions
@export var Equipable : bool = false
## Can the player drop this item? Set this flag to FALSE if this is a key item that cannot be dropped
@export var CanDrop : bool = true

