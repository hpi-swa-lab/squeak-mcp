forwarding
doesNotUnderstand: aMessage
	"We only override the streaming protocol we need to capture output.
	For everything else (window-model protocol like #windowColorToUse, etc.)
	behave like the real Transcript by forwarding to it. Falls back to the
	normal DNU behaviour if we have no original to delegate to."

	^ originalTranscript
		ifNil: [super doesNotUnderstand: aMessage]
		ifNotNil: [:orig | aMessage sendTo: orig]