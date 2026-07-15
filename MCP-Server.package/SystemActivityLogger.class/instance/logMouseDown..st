event handling
logMouseDown: anEvent
	| description lastEntry |
	description := self descriptionForMouseEventAt: anEvent position.
	lastEntry := log detect: [:e | (e at: #type) = #mouseDown] ifNone: [nil].

	(lastEntry notNil and: [(lastEntry at: #details) = description])
		ifTrue: [lastEntry at: #timestamp put: DateAndTime now]
		ifFalse: [self log: (Dictionary newFrom: {#type -> #mouseDown. #details -> description})]