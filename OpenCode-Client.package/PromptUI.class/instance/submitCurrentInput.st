actions
submitCurrentInput
	| text |
	text := inputText withBlanksTrimmed.
	text ifEmpty: [^ self].

	self addUserMessage: text.
	self addPendingAssistantMessage.
	self clearInput.
	self refreshDisplay.

	client sendPrompt: text.