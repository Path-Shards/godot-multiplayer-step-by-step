extends Control

const NO_MATCHES_MESSAGE := "No matches found."
const HOST_FAILED_MESSAGE := "Could not host a match."
const JOIN_FAILED_MESSAGE := "Could not join that match."
const HOST_DISCONNECTED_MESSAGE := "The host disconnected."

@export var connection: Connection
@export var discovery: Discovery

var _matches: Array = []
var _selected_address := ""
var _notice := ""
var _match_list_rule := MatchList.new()

@onready var _host_button: Button = $Controls/HostButton
@onready var _match_list: ItemList = $Controls/MatchList
@onready var _join_button: Button = $Controls/JoinButton
@onready var _waiting_label: Label = $Controls/WaitingLabel
@onready var _cancel_button: Button = $Controls/CancelButton
@onready var _message_label: Label = $Controls/MessageLabel
@onready var _advertise_timer: Timer = $AdvertiseTimer
@onready var _refresh_timer: Timer = $RefreshTimer


func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	multiplayer.connection_failed.connect(_on_connection_failed)
	discovery.start_listening()
	_redraw_matches()


func _on_host_button_pressed() -> void:
	_notice = ""
	if connection.host(Connection.PORT, Connection.MAX_CONNECTIONS) != Connection.Result.NONE:
		_show_notice(HOST_FAILED_MESSAGE)
		return
	_show_waiting()


func _on_match_list_item_selected(index: int) -> void:
	_selected_address = _matches[index]["address"]
	_join_button.visible = true


func _on_join_button_pressed() -> void:
	_notice = ""
	if connection.join(_selected_address, Connection.PORT) != Connection.Result.NONE:
		_show_notice(JOIN_FAILED_MESSAGE)


func _on_cancel_button_pressed() -> void:
	connection.close()
	_show_search()


func _on_connection_failed() -> void:
	connection.close()
	_show_notice(JOIN_FAILED_MESSAGE)


func _on_refresh_timer_timeout() -> void:
	discovery.start_listening()
	var now := Time.get_ticks_msec() / 1000.0
	for address in discovery.receive_announcements():
		_matches = _match_list_rule.register(_matches, address, now)
	_matches = _match_list_rule.drop_expired(_matches, now)
	_redraw_matches()


func _on_advertise_timer_timeout() -> void:
	discovery.advertise()


func _redraw_matches() -> void:
	_match_list.clear()
	for found in _matches:
		_match_list.add_item(found["address"])
	if _selected_address != "":
		for index in _matches.size():
			if _matches[index]["address"] == _selected_address:
				_match_list.select(index)
	_join_button.visible = _selected_address != ""
	_update_message()


func _update_message() -> void:
	if _notice != "":
		_message_label.text = _notice
		return
	_message_label.text = "" if _matches.size() > 0 else NO_MATCHES_MESSAGE


func _show_notice(text: String) -> void:
	_notice = text
	_update_message()


func _show_waiting() -> void:
	_host_button.visible = false
	_match_list.visible = false
	_join_button.visible = false
	_waiting_label.visible = true
	_cancel_button.visible = true
	_notice = ""
	_message_label.text = ""
	_refresh_timer.stop()
	discovery.stop_listening()
	discovery.advertise()
	_advertise_timer.start()


func _show_search() -> void:
	_host_button.visible = true
	_match_list.visible = true
	_waiting_label.visible = false
	_cancel_button.visible = false
	_matches = []
	_selected_address = ""
	_advertise_timer.stop()
	discovery.start_listening()
	_refresh_timer.start()
	_redraw_matches()


func _on_peer_connected(_peer_id: int) -> void:
	hide()


func _on_peer_disconnected(_peer_id: int) -> void:
	if not multiplayer.is_server():
		return
	show()
	_show_waiting()


func _on_server_disconnected() -> void:
	connection.close()
	show()
	_show_search()
	_show_notice(HOST_DISCONNECTED_MESSAGE)
