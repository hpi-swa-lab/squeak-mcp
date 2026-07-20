event handling
logClassEvent: type from: anEvent
	self shouldLogForCurrentAuthor ifFalse: [^ self].
	self log: (Dictionary newFrom: {
		#type -> type.
		#details -> anEvent item name.
		#class -> anEvent item name
	})