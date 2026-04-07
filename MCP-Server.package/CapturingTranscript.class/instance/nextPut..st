streaming
nextPut: aCharacter
	stream nextPut: aCharacter.
	originalTranscript ifNotNil: [:t | t nextPut: aCharacter]