streaming
show: anObject
	stream nextPutAll: anObject asString.
	originalTranscript ifNotNil: [originalTranscript show: anObject]