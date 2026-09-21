extends CharacterBody2D

const SPEED := 250.0
const LOCAL_TEXT := "You"
const REMOTE_TEXT := "Opponent"

var owner_peer_id := 0

@onready var _identity_label: Label = $IdentityLabel


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


@rpc("any_peer", "unreliable_ordered")
func _sync_position(remote_position: Vector2) -> void:
	position = remote_position


func _on_touch_zone_body_entered(body: Node2D) -> void:
	print("Something entered the area: ", body.name)
