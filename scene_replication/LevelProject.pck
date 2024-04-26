GDPC                                                                                          T   res://.godot/exported/133200997/export-061b3120f33bb556bd93cb7c3c990758-sphere.scn  @F      Q      �����5��l[��-�>    T   res://.godot/exported/133200997/export-36a25e342948d0ceacc500772b5412b3-player.scn  0      �      �e��?!ڙ���A�    X   res://.godot/exported/133200997/export-c0a6fb2ae0b5ca861fbcc035f2e73333-multiplayer.scn �!      c      �_g�
z��s���/f'    T   res://.godot/exported/133200997/export-d85448a68f01bbd6644b4b40ef87233e-level.scn   P      �      :Nk���^9���n�f    ,   res://.godot/global_script_class_cache.cfg  `P             ��Р�8���8~$}P�       res://.godot/uid_cache.bin  �P      |       _�b�8;�q򠲥�~l       res://level.gd          E      샮:��x��,���       res://level.tscn.remap  �N      b       �6�-j�p�	��)��       res://multiplayer.gd       z      ��j��?�����h�       res://multiplayer.tscn.remapO      h       � �{ѱ��.k��I       res://player.gd )      �      IX��"s�D�fS�ۼ+�       res://player.tscn.remap �O      c       ������T�?�L���       res://player_input.gd   �C      �      �N�^zl&Vu���Y"       res://project.binary Q      C      �p�bJƗ ��=���,       res://sphere.tscn.remap �O      c       )�����5#�Q�a�        extends Node3D

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
	for id in multiplayer.get_peers():
		add_player(id)

	# Spawn the local player unless this is a dedicated server export.
	if not OS.has_feature("dedicated_server"):
		add_player(1)
	
	dispatch_players()
	plot()


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


func del_player(id: int):
	if not $Players.has_node(str(id)):
		return
	$Players.get_node(str(id)).queue_free()

func dispatch_players():
	for k in playersDict.keys():
		if k != multiplayer.get_unique_id():
			playersDict[k].friend=playersDict[multiplayer.get_unique_id()]
			print("dispatch_players: done for ",multiplayer.get_unique_id())
		else:
			print("dispatch_players: ignored for ",multiplayer.get_unique_id())

func plot():
	print("plot():")
	for k in playersDict.keys():
		print("key: ",k, " - value: ",playersDict[k])
	print("i'm ",multiplayer.get_unique_id()," and my fiend is ",playersDict[multiplayer.get_unique_id()].friend.player)

func _physics_process(delta):
	if Input.is_action_pressed("show"):
		plot()
           RSRC                    PackedScene            ��������                                            �      ..    Players    .    playersDict    resource_local_to_scene    resource_name    custom_solver_bias    margin    plane    script    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    size    subdivide_width    subdivide_depth    center_offset    orientation    render_priority 
   next_pass    transparency    blend_mode 
   cull_mode    depth_draw_mode    no_depth_test    shading_mode    diffuse_mode    specular_mode    disable_ambient_light    disable_fog    vertex_color_use_as_albedo    vertex_color_is_srgb    albedo_color    albedo_texture    albedo_texture_force_srgb    albedo_texture_msdf 	   metallic    metallic_specular    metallic_texture    metallic_texture_channel 
   roughness    roughness_texture    roughness_texture_channel    emission_enabled 	   emission    emission_energy_multiplier    emission_operator    emission_on_uv2    emission_texture    normal_enabled    normal_scale    normal_texture    rim_enabled    rim 	   rim_tint    rim_texture    clearcoat_enabled 
   clearcoat    clearcoat_roughness    clearcoat_texture    anisotropy_enabled    anisotropy    anisotropy_flowmap    ao_enabled    ao_light_affect    ao_texture 
   ao_on_uv2    ao_texture_channel    heightmap_enabled    heightmap_scale    heightmap_deep_parallax    heightmap_flip_tangent    heightmap_flip_binormal    heightmap_texture    heightmap_flip_texture    subsurf_scatter_enabled    subsurf_scatter_strength    subsurf_scatter_skin_mode    subsurf_scatter_texture &   subsurf_scatter_transmittance_enabled $   subsurf_scatter_transmittance_color &   subsurf_scatter_transmittance_texture $   subsurf_scatter_transmittance_depth $   subsurf_scatter_transmittance_boost    backlight_enabled 
   backlight    backlight_texture    refraction_enabled    refraction_scale    refraction_texture    refraction_texture_channel    detail_enabled    detail_mask    detail_blend_mode    detail_uv_layer    detail_albedo    detail_normal 
   uv1_scale    uv1_offset    uv1_triplanar    uv1_triplanar_sharpness    uv1_world_triplanar 
   uv2_scale    uv2_offset    uv2_triplanar    uv2_triplanar_sharpness    uv2_world_triplanar    texture_filter    texture_repeat    disable_receive_shadows    shadow_to_opacity    billboard_mode    billboard_keep_scale    grow    grow_amount    fixed_size    use_point_size    point_size    use_particle_trails    proximity_fade_enabled    proximity_fade_distance    msdf_pixel_range    msdf_outline_size    distance_fade_mode    distance_fade_min_distance    distance_fade_max_distance    properties/0/path    properties/0/spawn    properties/0/replication_mode 	   _bundled       Script    res://level.gd ��������   PackedScene    res://sphere.tscn ���
�y`   #   local://WorldBoundaryShape3D_s66iy g         local://PlaneMesh_7cbpt �      !   local://StandardMaterial3D_kgp6f �      %   local://SceneReplicationConfig_ojalu �         local://PackedScene_gnpje D         WorldBoundaryShape3D    	      
   PlaneMesh       
     �A  �A	         StandardMaterial3D    #      ��(>���>  �?  �?	         SceneReplicationConfig    �              �         �         	         PackedScene    �      	         names "         World    script    Node3D 	   Camera3D 
   transform    Floor    StaticBody3D    CollisionShape3D    shape    MeshInstance3D    mesh    surface_material_override/0    OmniLight3D    light_energy    omni_range    Objects    Sphere    Sphere2    Players    MultiplayerSpawner    _spawnable_scenes    spawn_path    spawn_limit    MultiplayerSynchronizer    replication_config    	   variants                      �?              �?              �?    1��?�Q\@                                 �?              �?              �?    �&A          A   8�A              �?              �?              �?�F@r��@    "         res://player.tscn                                   node_count             nodes     n   ��������       ����                            ����                           ����                     ����                    	   	   ����   
                              ����                                       ����               ���                     ���            	                     ����                      ����      
                                 ����                   conn_count              conns               node_paths              editable_instances              version       	      RSRC        extends Node

const PORT = 4433

func _ready():
	# Start paused
	get_tree().paused = true
	# You can save bandwith by disabling server relay and peer notifications.
	multiplayer.server_relay = false

	# Automatically start the server in headless mode.
	if DisplayServer.get_name() == "headless":
		print("Automatically starting dedicated server")
		_on_host_pressed.call_deferred()


func _on_host_pressed():
	# Start as server
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server")
		return
	multiplayer.multiplayer_peer = peer
	start_game()


func _on_connect_pressed():
	# Start as client
	var txt : String = $UI/Net/Options/Remote.text
	if txt == "":
		OS.alert("Need a remote to connect to.")
		return
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(txt, PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client")
		return
	multiplayer.multiplayer_peer = peer
	start_game()

func start_game():
	# Hide the UI and unpause to start the game.
	$UI.hide()
	get_tree().paused = false
	# Only change level on the server.
	# Clients will instantiate the level via the spawner.
	if multiplayer.is_server():
		change_level.call_deferred(load("res://level.tscn"))


# Call this function deferred and only on the main authority (server).
func change_level(scene: PackedScene):
	# Remove old level if any.
	var level = $Level
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	# Add new level.
	level.add_child(scene.instantiate())

# The server can restart the level by pressing HOME.
func _input(event):
	if not multiplayer.is_server():
		return
	if event.is_action("ui_home") and Input.is_action_just_pressed("ui_home"):
		change_level.call_deferred(load("res://level.tscn"))

      RSRC                    PackedScene            ��������                                                  ..    Level    resource_local_to_scene    resource_name 	   _bundled    script       Script    res://multiplayer.gd ��������      local://PackedScene_46dwi          PackedScene          	         names "   $      Multiplayer    script    Node    Level    LevelSpawner    _spawnable_scenes    spawn_path    spawn_limit    MultiplayerSpawner    UI    process_mode    layout_mode    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    Control    Net    VBoxContainer    Options    HBoxContainer    Label    text    Host    Button    Connect    Remote    size_flags_horizontal    placeholder_text    caret_blink    caret_blink_interval 	   LineEdit    _on_host_pressed    pressed    _on_connect_pressed    	   variants                 "         res://level.tscn                                     �?            Direct:       Host       Connect    
   127.0.0.1       Remote Host             ?      node_count    
         nodes     �   ��������       ����                            ����                      ����                                    	   ����   
                                                           ����                                                        ����                          ����                                ����            	                    ����            
                     ����                                                 conn_count             conns               "   !                     "   #                    node_paths              editable_instances              version             RSRC             extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var test = $test
var local_player_character
var level
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Set by the authority, synchronized on spawn.
@export var player := 1 :
	set(id):
		player = id
		# Give authority over the player input to the appropriate peer.
		$PlayerInput.set_multiplayer_authority(id)

# Player synchronized input.
@onready var input = $PlayerInput

var friend : Node3D

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

@rpc("any_peer","call_local")
func _show():
		get_node("test").visible = true

@rpc("any_peer","call_local")
func _hide():
	get_node("test").visible = false
          RSRC                    PackedScene            ��������                                            �      .    player 	   position 	   velocity 
   direction    resource_local_to_scene    resource_name    properties/0/path    properties/0/spawn    properties/0/replication_mode    properties/1/path    properties/1/spawn    properties/1/replication_mode    properties/2/path    properties/2/spawn    properties/2/replication_mode    script    custom_solver_bias    margin    radius    height    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    radial_segments    rings    render_priority 
   next_pass    transparency    blend_mode 
   cull_mode    depth_draw_mode    no_depth_test    shading_mode    diffuse_mode    specular_mode    disable_ambient_light    disable_fog    vertex_color_use_as_albedo    vertex_color_is_srgb    albedo_color    albedo_texture    albedo_texture_force_srgb    albedo_texture_msdf 	   metallic    metallic_specular    metallic_texture    metallic_texture_channel 
   roughness    roughness_texture    roughness_texture_channel    emission_enabled 	   emission    emission_energy_multiplier    emission_operator    emission_on_uv2    emission_texture    normal_enabled    normal_scale    normal_texture    rim_enabled    rim 	   rim_tint    rim_texture    clearcoat_enabled 
   clearcoat    clearcoat_roughness    clearcoat_texture    anisotropy_enabled    anisotropy    anisotropy_flowmap    ao_enabled    ao_light_affect    ao_texture 
   ao_on_uv2    ao_texture_channel    heightmap_enabled    heightmap_scale    heightmap_deep_parallax    heightmap_flip_tangent    heightmap_flip_binormal    heightmap_texture    heightmap_flip_texture    subsurf_scatter_enabled    subsurf_scatter_strength    subsurf_scatter_skin_mode    subsurf_scatter_texture &   subsurf_scatter_transmittance_enabled $   subsurf_scatter_transmittance_color &   subsurf_scatter_transmittance_texture $   subsurf_scatter_transmittance_depth $   subsurf_scatter_transmittance_boost    backlight_enabled 
   backlight    backlight_texture    refraction_enabled    refraction_scale    refraction_texture    refraction_texture_channel    detail_enabled    detail_mask    detail_blend_mode    detail_uv_layer    detail_albedo    detail_normal 
   uv1_scale    uv1_offset    uv1_triplanar    uv1_triplanar_sharpness    uv1_world_triplanar 
   uv2_scale    uv2_offset    uv2_triplanar    uv2_triplanar_sharpness    uv2_world_triplanar    texture_filter    texture_repeat    disable_receive_shadows    shadow_to_opacity    billboard_mode    billboard_keep_scale    grow    grow_amount    fixed_size    use_point_size    point_size    use_particle_trails    proximity_fade_enabled    proximity_fade_distance    msdf_pixel_range    msdf_outline_size    distance_fade_mode    distance_fade_min_distance    distance_fade_max_distance    left_to_right    size    subdivide_width    subdivide_height    subdivide_depth 	   _bundled       Script    res://player.gd ��������   Script    res://player_input.gd ��������   %   local://SceneReplicationConfig_fb1vy �      %   local://SceneReplicationConfig_hoavk @         local://CapsuleShape3D_37qaq �         local://CapsuleMesh_jab13 �      !   local://StandardMaterial3D_tm6xc �         local://PrismMesh_4ku1o 	         local://PackedScene_g517l 3         SceneReplicationConfig 
                           	          
                                                                           SceneReplicationConfig                             	                  CapsuleShape3D             CapsuleMesh             StandardMaterial3D    +        �?д4>  �?  �?      
   PrismMesh                         PackedScene    �      	         names "         Player    script    CharacterBody3D    ServerSynchronizer    replication_config    MultiplayerSynchronizer    PlayerInput 
   root_path    CollisionShape3D    shape    MeshInstance3D    mesh 	   Camera3D 
   transform    test    Node3D    Timer 
   wait_time 	   one_shot    	   variants                                                                              �?              �?              �?    ���?�@     �?              �?              �?    �!�?��              @@            node_count    	         nodes     W   ��������       ����                            ����                           ����                                       ����   	                  
   
   ����                           ����                           ����               
   
   ����            	                    ����      
                   conn_count              conns               node_paths              editable_instances              version             RSRC     extends MultiplayerSynchronizer

# Set via RPC to simulate is_action_just_pressed.
@export var jumping := false

# Synchronized property.
@export var direction := Vector2()

func _ready():
	# Only process for the local player
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())


@rpc("call_local")
func jump():
	jumping = true

func _process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if Input.is_action_just_pressed("ui_accept"):
		jump.rpc()
     RSRC                    PackedScene            ��������                                            (      ..    CollisionShape3D    .    linear_velocity    angular_velocity 	   position 	   rotation    resource_local_to_scene    resource_name 	   friction    rough    bounce 
   absorbent    script    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    radius    height    radial_segments    rings    is_hemisphere    custom_solver_bias    margin    properties/0/path    properties/0/spawn    properties/0/replication_mode    properties/1/path    properties/1/spawn    properties/1/replication_mode    properties/2/path    properties/2/spawn    properties/2/replication_mode    properties/3/path    properties/3/spawn    properties/3/replication_mode 	   _bundled           local://PhysicsMaterial_mp5c4           local://SphereMesh_deuj3 X         local://SphereShape3D_h6jr2 s      %   local://SceneReplicationConfig_q1o6k �         local://PackedScene_ooayu h         PhysicsMaterial    	                  �?         SphereMesh             SphereShape3D             SceneReplicationConfig                                                                     !              "         #         $              %         &                  PackedScene    '      	         names "         Sphere 
   transform    physics_material_override    RigidBody3D    MeshInstance3D    mesh 	   skeleton    CollisionShape3D    shape    MultiplayerSynchronizer    replication_config    	   variants            �?              �?              �?    qr@                                                            node_count             nodes     (   ��������       ����                                  ����                                 ����                     	   	   ����   
                conn_count              conns               node_paths              editable_instances              version             RSRC               [remap]

path="res://.godot/exported/133200997/export-d85448a68f01bbd6644b4b40ef87233e-level.scn"
              [remap]

path="res://.godot/exported/133200997/export-c0a6fb2ae0b5ca861fbcc035f2e73333-multiplayer.scn"
        [remap]

path="res://.godot/exported/133200997/export-36a25e342948d0ceacc500772b5412b3-player.scn"
             [remap]

path="res://.godot/exported/133200997/export-061b3120f33bb556bd93cb7c3c990758-sphere.scn"
             list=Array[Dictionary]([])
        ����V�   res://level.tscn��5t9��5   res://multiplayer.tscn���r�X   res://player.tscn���
�y`   res://sphere.tscn    ECFG      application/run/main_scene          res://multiplayer.tscn     application/config/features   "         4.2 
   input/show�              events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   X   	   key_label             unicode    x      echo          script            deadzone      ?             