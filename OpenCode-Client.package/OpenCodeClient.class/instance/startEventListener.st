private
startEventListener
	"Start SSE listener if not already running."
	(eventProcess notNil and: [eventProcess isTerminated not])
		ifTrue: [^ self].

	eventProcess := [self eventListenerLoop]
		forkAt: Processor userBackgroundPriority
		named: 'OpenCode-EventListener'.