private
ensureSession: aBlock
	"Create session if needed, then evaluate block."
	sessionId ifNotNil: [ ^ aBlock value ].

	[
		| response data |
		response := self httpPost: '/session' json: {'title' -> 'Squeak Session'} asDictionary.
		(response at: #code) = 200 ifTrue: [
			data := self parseJson: (response at: #content).
			sessionId := data at: 'id'.
			aBlock value.
		] ifFalse: [
			Transcript show: 'Failed to create session'; cr.
		].
	] fork.