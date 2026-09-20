class_name Discovery
extends Node

const DISCOVERY_PORT := 8911
const ANNOUNCE_ADDRESSES: PackedStringArray = ["255.255.255.255", "127.0.0.1"]
const MARKER := "MY_MULTIPLAYER_GAME_HOST"

var _sender: PacketPeerUDP
var _listener: PacketPeerUDP


func advertise() -> void:
	if _sender == null:
		_sender = PacketPeerUDP.new()
		_sender.set_broadcast_enabled(true)
	var payload := MARKER.to_utf8_buffer()
	for address in ANNOUNCE_ADDRESSES:
		_sender.set_dest_address(address, DISCOVERY_PORT)
		_sender.put_packet(payload)


func start_listening() -> void:
	if _listener != null:
		return
	var socket := PacketPeerUDP.new()
	if socket.bind(DISCOVERY_PORT) != OK:
		return
	_listener = socket


func stop_listening() -> void:
	if _listener == null:
		return
	_listener.close()
	_listener = null


func receive_announcements() -> Array:
	var addresses: Array = []
	if _listener == null:
		return addresses
	while _listener.get_available_packet_count() > 0:
		if _listener.get_packet().get_string_from_utf8() == MARKER:
			addresses.append(_listener.get_packet_ip())
	return addresses
