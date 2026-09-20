extends GutTest


func test_should_return_none_when_hosting_on_a_free_port():
	# Arrange
	var client := preload("res://network/connection.gd").new()
	add_child_autofree(client)

	# Act
	var result := client.host(8912, 1)

	# Assert
	assert_eq(result, Connection.Result.NONE)
