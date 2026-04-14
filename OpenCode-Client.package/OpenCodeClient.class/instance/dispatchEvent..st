private
dispatchEvent: anEvent
	"Route event to appropriate handler."
	| type props |
	type := anEvent at: 'type' ifAbsent: [^ self].
	props := anEvent at: 'properties' ifAbsent: [^ self].

	(self eventMatchesSession: props) ifFalse: [^ self].

	type = 'message.part.updated' ifTrue: [
		self handleMessagePart: (props at: 'part' ifAbsent: [^ self])].