extends CharacterBody2D

signal contact_changed(other: Node2D, touching: bool)

const SPEED := 250.0
const LOCAL_TEXT := "You"
const REMOTE_TEXT := "Opponent"
const TAGGER_COLOR := Color("f2400d")
const RUNNER_COLOR := Color("8c949e")

var owner_peer_id := 0

@onready var _identity_label: Label = $IdentityLabel
@onready var _visual: Polygon2D = $Visual


func _ready() -> void:
	if owner_peer_id == multiplayer.get_unique_id():
		_identity_label.text = LOCAL_TEXT
	else:
		_identity_label.text = REMOTE_TEXT


func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += direction * SPEED * delta
	_sync_position.rpc(position)


func set_tagger(is_tagger: bool) -> void:
	_visual.color = TAGGER_COLOR if is_tagger else RUNNER_COLOR


@rpc("any_peer", "unreliable_ordered")
func _sync_position(remote_position: Vector2) -> void:
	position = remote_position


func _on_touch_zone_body_entered(body: Node2D) -> void:
	contact_changed.emit(body, true)


func _on_touch_zone_body_exited(body: Node2D) -> void:
	contact_changed.emit(body, false)
