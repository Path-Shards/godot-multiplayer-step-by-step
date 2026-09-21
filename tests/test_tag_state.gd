extends GutTest


func test_should_keep_the_given_ids_when_the_state_is_created():
	# Arrange
	var state := TagState.new(1, 77)

	# Act
	var tagger := state.tagger_peer_id

	# Assert
	assert_eq(tagger, 1)
	assert_eq(state.runner_peer_id, 77)
	assert_false(state.in_contact)


func test_should_answer_true_when_the_peer_is_the_tagger():
	# Arrange
	var state := TagState.new(1, 77)

	# Act
	var answer := state.is_tagger(1)

	# Assert
	assert_true(answer)


func test_should_answer_false_when_the_peer_is_the_runner():
	# Arrange
	var state := TagState.new(1, 77)

	# Act
	var answer := state.is_tagger(77)

	# Assert
	assert_false(answer)


func test_should_exchange_the_two_ids_when_swapping():
	# Arrange
	var state := TagState.new(1, 77)

	# Act
	state.swap()

	# Assert
	assert_eq(state.tagger_peer_id, 77)
	assert_eq(state.runner_peer_id, 1)
