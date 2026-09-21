class_name TagState
extends RefCounted

var tagger_peer_id: int
var runner_peer_id: int
var in_contact: bool


func _init(tagger_id: int, runner_id: int, contact: bool = false) -> void:
	tagger_peer_id = tagger_id
	runner_peer_id = runner_id
	in_contact = contact


func is_tagger(peer_id: int) -> bool:
	return peer_id == tagger_peer_id


func swap() -> void:
	var previous_tagger := tagger_peer_id
	tagger_peer_id = runner_peer_id
	runner_peer_id = previous_tagger
