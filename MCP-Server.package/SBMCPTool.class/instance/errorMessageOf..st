error reporting
errorMessageOf: anException
	"Some exceptions fail to build their messageText (e.g. SyntaxErrorNotification without a cue); an error in a handler would escape it."
	| text |
	text := [anException messageText] on: Error do: [nil].
	^ (text isNil or: [text isEmpty])
		ifTrue: [anException class name asString]
		ifFalse: [anException class name, ': ', text]