initialization
setupStreamingCallback
	client onMessagePartReceived: [:part |
		self handleIncomingPart: part].