event handling
filterEvent: anEvent for: aMorph
	(anEvent isMouse and: [anEvent isMouseDown])
		ifTrue: [self logMouseDown: anEvent].
	^ anEvent