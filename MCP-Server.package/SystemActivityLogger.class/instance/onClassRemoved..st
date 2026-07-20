event handling
onClassRemoved: anEvent
	self shouldLogForCurrentAuthor ifFalse: [^ self].
	self log: (Dictionary newFrom: {#type -> #classRemoved. #details -> anEvent item})