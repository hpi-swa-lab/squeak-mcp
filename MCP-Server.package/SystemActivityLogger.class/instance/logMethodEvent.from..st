event handling
logMethodEvent: type from: anEvent
	self shouldLogForCurrentAuthor ifFalse: [^ self].
	self log: {
		#type -> type.
		#details -> (anEvent itemClass name, '>>', anEvent itemSelector).
		#class -> anEvent itemClass name.
		#selector -> anEvent itemSelector
	} asDictionary