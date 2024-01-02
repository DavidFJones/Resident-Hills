@tool
extends Resource
class_name CustomItems

@export_group("Item Properties")
## The unique id of this item. Used to grab the following data from an external data source
@export var ID : int = 0
@export var Name : String = "Name"
@export var Description : String = "Description"
@export var Img : CompressedTexture2D
## Used to determine the "most important" item the player should interact with if multiple items are overlapping
@export var Priority := 1
@export_group("Stacking Settings")
## Used to see if this item should stack in the inventory
@export var Stackable : bool = false
## What is the maximum amount for a stack of this item
@export var MaxStackCount : int = 0
## How many counts of the item should this specific instance of the item conatain? (IE: should this ammo box start with 5 rounds)
@export var StartingStackCount : int = 0
@export_group("Usage Settings")
## Is this item equipable? Used later on by the inventory system to handle equip interactions
@export var Equipable : bool = false
## Can the player combine this with other items?
@export var CanCombine : bool = false
## Can the player drop this item? Set this flag to FALSE if this is a key item that cannot be dropped
@export var CanDrop : bool = true
@export_group("Ammo Settings")
## How much ammo this item holds (can be used for things like bullets, or battery charges
@export var MaxAmmo : int = 0
## How much ammo this item starts with
@export var StartingAmmo : int = 0
#used to determine if the current item is equipped
var IsEquipped : bool = false
#used to see what our current ammo is for an item that has ammo
var CurrentAmmo : int = 0
#used for key items. Allows the game to change if this item can be dropped after certain conditions are met
var HasBeenUsed : bool = false

