class_name TagRules
extends RefCounted


func first_state(host_peer_id: int, client_peer_id: int) -> TagState:
	return TagState.new(host_peer_id, client_peer_id)


func resolve(state: TagState, in_contact_now: bool) -> TagState:
	if in_contact_now and not state.in_contact:
		state.swap()
	state.in_contact = in_contact_now
	return state
