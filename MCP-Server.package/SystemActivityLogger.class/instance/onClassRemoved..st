event handling
onClassRemoved: anEvent
	self shouldLogForCurrentAuthor ifFalse: [^ self].
	self log: {#type -> #classRemoved. #details -> anEvent item} asDictionary