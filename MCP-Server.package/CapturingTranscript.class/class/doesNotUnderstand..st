as yet unclassified
doesNotUnderstand: aMessage
	"Some code sends Transcript-display protocol (e.g. #forceUpdate) to the
	class rather than an instance. Forward such messages to the live global
	Transcript instance, which knows how to delegate to the real transcript.
	Fall back to normal DNU if the global isn't one of us (avoid loops)."

	"CapturingTranscript stands in for TranscriptStream. Class-side protocol
	such as the #forceUpdate preference lives on TranscriptStream class, which
	we do not inherit from, so forward there."
	^ (TranscriptStream class canUnderstand: aMessage selector)
		ifTrue: [aMessage sendTo: TranscriptStream]
		ifFalse: [super doesNotUnderstand: aMessage]