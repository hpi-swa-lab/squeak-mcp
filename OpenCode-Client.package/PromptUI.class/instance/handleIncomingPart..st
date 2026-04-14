streaming handler
handleIncomingPart: aPart
	| msg type delta content |
	msg := self currentAssistantMessage.
	msg ifNil: [^ self].

	type := aPart at: #type ifAbsent: ['text'].

	type = 'text' ifTrue: [
		delta := aPart at: #delta ifAbsent: [nil].
		delta
			ifNotNil: [msg appendContent: delta]
			ifNil: [
				content := aPart at: #content ifAbsent: [''].
				content ifNotEmpty: [msg content: content]].
		msg beStreaming.
		self refreshDisplay.
	].

	(type = 'step-start') ifTrue: [msg beThinking. self refreshDisplay].
	(type = 'step-finish') ifTrue: [msg beDone. self refreshDisplay].