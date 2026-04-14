public
sendPrompt: aString
	"Send a prompt asynchronously with streaming response.
	Responses arrive via onMessagePartReceived callback."
	self ensureSession: [
		self startEventListener.
		self postPromptAsync: aString.
	].