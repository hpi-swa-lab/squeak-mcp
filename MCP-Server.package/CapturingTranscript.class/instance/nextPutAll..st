streaming
nextPutAll: aString
	stream nextPutAll: aString.
	originalTranscript ifNotNil: [:t | t nextPutAll: aString]