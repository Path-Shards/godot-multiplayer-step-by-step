extends Control

const NO_MATCHES_MESSAGE := "No matches found."
const HOST_FAILED_MESSAGE := "Could not host a match."

@export var connection: Connection

@onready var _host_button: Button = $Controls/HostButton
@onready var _match_list: ItemList = $Controls/MatchList
@onready var _join_button: Button = $Controls/JoinButton
@onready var _waiting_label: Label = $Controls/WaitingLabel
@onready var _message_label: Label = $Controls/MessageLabel


func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	_message_label.text = NO_MATCHES_MESSAGE


func _on_host_button_pressed() -> void:
	if connection.host(Connection.PORT, Connection.MAX_CONNECTIONS) != Connection.Result.NONE:
		_message_label.text = HOST_FAILED_MESSAGE
		return
	_show_waiting()


func _show_waiting() -> void:
	_host_button.visible = false
	_match_list.visible = false
	_join_button.visible = false
	_message_label.text = ""
	_waiting_label.visible = true


func _on_peer_connected(_peer_id: int) -> void:
	hide()
