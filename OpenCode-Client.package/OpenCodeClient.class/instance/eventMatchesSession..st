private
eventMatchesSession: props
	"Check if event belongs to our session."
	| eventSessionId |
	eventSessionId := props at: 'sessionID' ifAbsent: [
		(props at: 'part' ifAbsent: [Dictionary new])
			at: 'sessionID' ifAbsent: [nil]].
	^ eventSessionId = sessionId