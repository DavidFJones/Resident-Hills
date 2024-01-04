extends CharacterBody3D

#bool used to prevent player movement while using the inventory
var inventoryOpen := false

#reference to our players interaction collision box
var interactionBoxNode

#base walking speed for the player
@export var walkSpeed = 5.0

#reference to main camera, I don't like how coupled this is at the moment
var mainCamera

#Reference to child collider that the camera will collide with for raycasts
var cameraLookCollider

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	#If we do not have a main camera
	#and if there is one in the scenetree, get a reference to it
	if mainCamera == null:
		if get_tree().get_nodes_in_group("Main Camera"):
			mainCamera = get_tree().get_nodes_in_group("Main Camera")[0]

	#if we do not have a camera floor collider, get reference
	if cameraLookCollider == null:
		cameraLookCollider = $CameraLookCollider

	interactionBoxNode = $ItemCheckBox

func rotate_Player():
	
	if mainCamera == null:
		return
	
	# Get the mouse position in the viewport
	var mousePosition = get_viewport().get_mouse_position()
	
	# Use the unproject_position method to convert the mouse position to a 3D world position
	var rayOrigin = mainCamera.project_ray_origin(mousePosition)
	var rayDirection = mainCamera.project_ray_normal(mousePosition)

	# Perform a raycast in the scene
	# Set the space state
	var spaceState = get_world_3d().direct_space_state
	# set the parameters for the intersect_ray (Note, in godot 3. these would be multiple arguments,
	# in 4. they changed intersect_ray to instead take a single PhysicsRayQueryParameters3D node
	var parameters = PhysicsRayQueryParameters3D.create(rayOrigin, rayOrigin + rayDirection * 10000,32768) 
	#cast the ray
	var ray_result = spaceState.intersect_ray(parameters)

	# Check if there is a collision
	if ray_result:
		# Get the intersection point
		var intersection_point = ray_result.position

		# Use the intersection_point as needed
		look_at(intersection_point, Vector3(0, 1, 0))
		
		# Manually reset the x/z rotation because Godot is dumb and axis lock doesn't actually work
		rotation_degrees = Vector3(0, rotation_degrees.y, 0)

func move_Player(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("input_Left", "input_Right", "input_Forward", "input_Backward")
	var direction = (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * walkSpeed
		velocity.z = direction.z * walkSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, walkSpeed)
		velocity.z = move_toward(velocity.z, 0, walkSpeed)

	move_and_slide()

func toggle_inventory():
	inventoryOpen = !inventoryOpen
	GameManager.inventoryUI.toggle_inventory_open(inventoryOpen)

func interact():
	#reference for the object we wish to interact with 
	var item
	
	var highestPriority = 0
	#loop through all collisions, and get the one with the highest priority
	for body in interactionBoxNode.get_overlapping_bodies():
		if body.is_in_group("Interactables"):
			if body.CustomItem.Priority > highestPriority:
				item = body
				highestPriority = body.CustomItem.Priority

	#tell the object we want to interact with it if if we found one
	if highestPriority > 0:
		item.interaction()

func passInteraction(item,interactionType):
	#a really ugly way of interacting with an object, 
	#then having that object "dynamically" talk to our inventory if needed

	#checks for a string type and uses that to determine what to do wit
	if interactionType == "itemPickup":
		GameManager.inventodryUI.pickup_item(item)

func _physics_process(delta):
	if Input.is_action_just_pressed("input_inventory"):
		toggle_inventory()

	if inventoryOpen:
		return

	if Input.is_action_just_pressed("input_Interact"):
		interact()

	rotate_Player()

	move_Player(delta)
