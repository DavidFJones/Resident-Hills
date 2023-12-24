extends Camera3D


var lookTarget

@export var defaultCameraPosition := Vector2(9,4.5)

@export var cameraSmooth := 2

# Called when the node enters the scene tree for the first time.
func _ready():
	#If we do not yet have a look target, search for the first object in the player group in the scene
	if lookTarget == null:
		#if there is a Player group object in the scene, assign it
		if get_tree().get_nodes_in_group("Player"):
			lookTarget = get_tree().get_nodes_in_group("Player")[0]
			
			#force the camera to the players position on the first frame, so the smooth movement
			#doesn't cause issues with the cameras scene position placement
			self.position = Vector3(
			lookTarget.position.x, 
			lookTarget.position.y + defaultCameraPosition.x, 
			lookTarget.position.z + defaultCameraPosition.y)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if lookTarget == null:
		return
	#move the camera's position to match their target, multiplied by the set offset
	
	#set the desired look position
	var newTarget = Vector3(
		lookTarget.position.x, 
		lookTarget.position.y + defaultCameraPosition.x, 
		lookTarget.position.z + defaultCameraPosition.y)
	
	# Interpolate the current camera position towards the target position
	var newPosition: Vector3 = lerp(self.position, newTarget, cameraSmooth * delta)
	
	self.position = newPosition
