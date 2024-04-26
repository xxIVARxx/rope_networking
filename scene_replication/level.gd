extends Node3D

const SPAWN_RANDOM := 5.0

var playersDict = {}


func _ready():
	print("LevelReady():")
	# We only need to spawn players on the server.
	if not multiplayer.is_server():
		return

	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)

	# Spawn already connected players
	#for id in multiplayer.get_peers():
		#add_player(id)

	# Spawn the local player unless this is a dedicated server export.
	if not OS.has_feature("dedicated_server"):
		add_player(1)
	
	dispatch_players()
	plot()
	set_friend()

func _exit_tree():
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)


func add_player(id: int):
	var character = preload("res://player.tscn").instantiate()
	# Set player id.
	playersDict[id] = character
	character.player = id
	character.level = self
	# Randomize character position.
	var pos := Vector2.from_angle(randf() * 2 * PI)
	character.position = Vector3(pos.x * SPAWN_RANDOM * randf(), 0, pos.y * SPAWN_RANDOM * randf())
	character.name = str(id)
	$Players.add_child(character, true)
	dispatch_players()

func del_player(id: int):
	if not $Players.has_node(str(id)):
		return
	$Players.get_node(str(id)).queue_free()

func dispatch_players():
	for p in playersDict.keys():
		for f in playersDict.keys():
			if f != p:
				playersDict[p].friend = playersDict[f]
				print("set friendship: ", p, " -> ",f)

func plot():
	print("plot():")
	for k in playersDict.keys():
		print("key: ",k, " - value: ",playersDict[k])
	dispatch_players()
	if playersDict[multiplayer.get_unique_id()]:
		print("i'm ",multiplayer.get_unique_id()," and my fiend is ",playersDict[multiplayer.get_unique_id()])

func _physics_process(delta):
	if Input.is_action_pressed("show"):
		plot()
		

func set_friend():
	for k in playersDict.keys():
		var friend = playersDict[k]
		print("friend id",friend)
