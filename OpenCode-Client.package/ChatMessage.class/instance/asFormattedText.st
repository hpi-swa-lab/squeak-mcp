formatting
asFormattedText
	^ self isUser
		ifTrue: [self formatUserMessage]
		ifFalse: [self formatAssistantMessage]