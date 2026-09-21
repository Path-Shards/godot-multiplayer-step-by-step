class_name Connection
extends Node

const PORT := 8910
const MAX_CONNECTIONS := 1


enum Result {
	NONE,
	HOST_UNAVAILABLE,
}


func host(port: int, max_connections: int) -> Result:
	var peer := ENetMultiplayerPeer.new()
	if peer.create_server(port, max_connections) != OK:
		return Result.HOST_UNAVAILABLE
	multiplayer.multiplayer_peer = peer
	return Result.NONE


func join(address: String, port: int) -> Result:
	var peer := ENetMultiplayerPeer.new()
	if peer.create_client(address, port) != OK:
		return Result.HOST_UNAVAILABLE
	multiplayer.multiplayer_peer = peer
	return Result.NONE


func close() -> void:
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
