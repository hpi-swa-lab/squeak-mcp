streaming
nl
	stream cr.
	originalTranscript ifNotNil: [:t |
		(t respondsTo: #nl) ifTrue: [t nl] ifFalse: [t cr]]