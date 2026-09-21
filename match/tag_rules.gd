class_name TagRules
extends RefCounted


func first_state(host_peer_id: int, client_peer_id: int) -> TagState:
	return TagState.new(host_peer_id, client_peer_id)
