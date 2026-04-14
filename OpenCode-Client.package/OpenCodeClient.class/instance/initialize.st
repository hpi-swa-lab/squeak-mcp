initialization
initialize
	super initialize.
	serverUrl := self class defaultServerUrl.
	sessionId := nil.
	eventProcess := nil.
	onMessagePartReceived := [:part | "default: do nothing"].