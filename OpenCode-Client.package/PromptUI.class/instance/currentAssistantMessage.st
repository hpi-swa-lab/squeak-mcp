conversation management
currentAssistantMessage
	"Return the last assistant message, or nil."
	conversation ifEmpty: [^ nil].
	^ (conversation last isAssistant)
		ifTrue: [conversation last]
		ifFalse: [nil]