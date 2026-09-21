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
