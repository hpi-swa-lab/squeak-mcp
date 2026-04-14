initialization
initialize
	super initialize.
	client := OpenCodeClient new.
	conversation := OrderedCollection new.
	inputText := ''.
	cachedDisplayText := self welcomeText.
	builder := nil.

	self setupStreamingCallback.