extends Node2D

const PLAYER_SCENE := preload("res://Player.tscn")
const HOST_PEER_ID := 1
const HOST_START := Vector2(280, 324)
const CLIENT_START := Vector2(872, 324)


func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)


func _on_peer_connected(peer_id: int) -> void:
	if not multiplayer.is_server():
		return
	_start_match(peer_id)


func _on_connected_to_server() -> void:
	_start_match(multiplayer.get_unique_id())


func _start_match(client_peer_id: int) -> void:
	_spawn_player(HOST_PEER_ID, HOST_START)
	_spawn_player(client_peer_id, CLIENT_START)


func _spawn_player(peer_id: int, start_position: Vector2) -> void:
	var player := PLAYER_SCENE.instantiate()
	player.name = "Player%d" % peer_id
	player.position = start_position
	player.owner_peer_id = peer_id
	add_child(player, true)
	player.set_multiplayer_authority(peer_id)
