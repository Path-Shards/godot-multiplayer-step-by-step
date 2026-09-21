extends GutTest


func test_should_return_none_when_hosting_on_a_free_port():
	# Arrange
	var client := preload("res://network/connection.gd").new()
	add_child_autofree(client)

	# Act
	var result := client.host(8912, 1)

	# Assert
	assert_eq(result, Connection.Result.NONE)


func test_should_free_the_port_when_the_connection_is_closed():
	# Arrange
	var client := preload("res://network/connection.gd").new()
	add_child_autofree(client)
	client.host(8913, 1)

	# Act
	client.close()
	var result := client.host(8913, 1)

	# Assert
	assert_eq(result, Connection.Result.NONE)
