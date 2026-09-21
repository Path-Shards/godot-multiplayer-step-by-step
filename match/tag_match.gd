extends Node

const HOST_PEER_ID := 1

var _rules := TagRules.new()
var _state: TagState
var _players: Dictionary = {}


func add_player(peer_id: int, player: CharacterBody2D) -> void:
	_players[peer_id] = player
	player.contact_changed.connect(_on_contact_changed.bind(player))


func start(host_peer_id: int, client_peer_id: int) -> void:
	if not multiplayer.is_server():
		_request_state.rpc_id(HOST_PEER_ID)
		return
	_state = _rules.first_state(host_peer_id, client_peer_id)
	_broadcast_state()


func stop() -> void:
	for peer_id in _players:
		_players[peer_id].queue_free()
	_players.clear()
	_state = null


func _on_contact_changed(body: Node2D, touching: bool, zone_owner: CharacterBody2D) -> void:
	if not multiplayer.is_server() or body == zone_owner or _state == null:
		return
	_state = _rules.resolve(_state, touching)
	_broadcast_state()


func _broadcast_state() -> void:
	_sync_state.rpc(_state.tagger_peer_id, _state.runner_peer_id, _state.in_contact)


@rpc("any_peer", "reliable")
func _request_state() -> void:
	if multiplayer.is_server() and _state != null:
		_broadcast_state()


@rpc("authority", "call_local", "reliable")
func _sync_state(tagger_peer_id: int, runner_peer_id: int, in_contact: bool) -> void:
	_state = TagState.new(tagger_peer_id, runner_peer_id, in_contact)
	for peer_id in _players:
		_players[peer_id].set_tagger(_state.is_tagger(peer_id))
