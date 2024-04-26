extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var test = $test
var local_player_character
var level
var _is_hitting = false
var hookNode: Node3D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var HookScene = preload("res://grappling_hook_3d/src/hook.tscn")
var hook_target_position : Vector3
var source_posiition = Node3D
var _hook_target_normal: Vector3

# Set by the authority, synchronized on spawn.
@export var player := 1 :
	set(id):
		player = id
		# Give authority over the player input to the appropriate peer.
		$PlayerInput.set_multiplayer_authority(id)

# Player synchronized input.
@onready var input = $PlayerInput

var friend : CharacterBody3D

func _ready():
	# Set the camera as current if we are this player.
	if player == multiplayer.get_unique_id():
		$Camera3D.current = true
	get_node("test").visible = false
	# Only process on server.
	# EDIT: Left the client simulate player movement too to compesate network latency.
	# set_physics_process(multiplayer.is_server())


func _physics_process(delta):
	# Add the gravity.
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if input.jumping and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Reset jump state.
	input.jumping = false

	# Handle movement.
	var direction = (transform.basis * Vector3(input.direction.x, 0, input.direction.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	if player == multiplayer.get_unique_id():
		if Input.is_action_pressed("show"):
			if level:
				level.plot()
			_show.rpc()
		else:
			_hide.rpc()
	
	if player == multiplayer.get_unique_id():
		if Input.is_action_pressed("laser"):
			emit_hook.rpc()
			handle_hook.rpc()
	
@rpc("any_peer","call_local")
func _show():
		get_node("test").visible = true

@rpc("any_peer","call_local")
func _hide():
	get_node("test").visible = false
	
	
@rpc("any_peer", "call_local")
func emit_hook():
	if not friend:
		return
	if _is_hitting:
		print("already running")
		return
	hookNode = HookScene.instantiate()
	add_child(hookNode)

	
@rpc("any_peer", "call_local")
func handle_hook():
	if not friend:
		return
	hook_target_position = friend.global_position
	source_posiition = position
	hookNode.extend_from_to(source_posiition, hook_target_position, _hook_target_normal)

