extends GutTest


func test_should_add_the_match_when_the_address_is_new():
	# Arrange
	var match_list := MatchList.new()

	# Act
	var found := match_list.register([], "192.168.0.10", 1.0)

	# Assert
	assert_eq(found.size(), 1)
	assert_eq(found[0]["address"], "192.168.0.10")
	assert_eq(found[0]["seen_at"], 1.0)


func test_should_refresh_the_timestamp_when_the_address_is_already_listed():
	# Arrange
	var match_list := MatchList.new()
	var found := match_list.register([], "192.168.0.10", 1.0)

	# Act
	found = match_list.register(found, "192.168.0.10", 2.5)

	# Assert
	assert_eq(found.size(), 1)
	assert_eq(found[0]["seen_at"], 2.5)


func test_should_drop_the_match_when_it_stopped_advertising():
	# Arrange
	var match_list := MatchList.new()
	var found := match_list.register([], "192.168.0.10", 1.0)

	# Act
	found = match_list.drop_expired(found, 1.0 + MatchList.LIFETIME_SECONDS + 0.1)

	# Assert
	assert_eq(found.size(), 0)


func test_should_keep_the_match_when_it_is_still_advertising():
	# Arrange
	var match_list := MatchList.new()
	var found := match_list.register([], "192.168.0.10", 1.0)

	# Act
	found = match_list.drop_expired(found, 1.0 + MatchList.LIFETIME_SECONDS - 0.1)

	# Assert
	assert_eq(found.size(), 1)
