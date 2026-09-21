extends GutTest


func test_should_make_the_host_the_tagger_when_the_match_starts():
	# Arrange
	var rules := TagRules.new()

	# Act
	var state := rules.first_state(1, 77)

	# Assert
	assert_true(state.is_tagger(1))


func test_should_make_the_client_the_runner_when_the_match_starts():
	# Arrange
	var rules := TagRules.new()

	# Act
	var state := rules.first_state(1, 77)

	# Assert
	assert_false(state.is_tagger(77))


func test_should_swap_the_roles_when_the_contact_starts():
	# Arrange
	var rules := TagRules.new()
	var state := TagState.new(1, 77, false)

	# Act
	rules.resolve(state, true)

	# Assert
	assert_true(state.is_tagger(77))


func test_should_keep_the_roles_when_the_contact_was_already_true():
	# Arrange
	var rules := TagRules.new()
	var state := TagState.new(1, 77, true)

	# Act
	rules.resolve(state, true)

	# Assert
	assert_true(state.is_tagger(1))


func test_should_keep_the_roles_when_there_is_no_contact():
	# Arrange
	var rules := TagRules.new()
	var state := TagState.new(1, 77, false)

	# Act
	rules.resolve(state, false)

	# Assert
	assert_true(state.is_tagger(1))


func test_should_forget_the_contact_when_the_bodies_separate():
	# Arrange
	var rules := TagRules.new()
	var state := TagState.new(1, 77, true)

	# Act
	rules.resolve(state, false)

	# Assert
	assert_false(state.in_contact)
