public
disconnect
	"Stop the event listener and clear session."
	eventProcess ifNotNil: [
		eventProcess terminate.
		eventProcess := nil.
	].
	sessionId := nil.