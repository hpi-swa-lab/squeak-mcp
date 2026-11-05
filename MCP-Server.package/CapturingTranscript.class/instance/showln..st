printing
showln: anObject
	"Like TranscriptStream>>showln:, a new line before the message. Used e.g. for compiler warnings."

	stream cr; nextPutAll: anObject asString.
	originalTranscript ifNotNil: [:t | t showln: anObject]