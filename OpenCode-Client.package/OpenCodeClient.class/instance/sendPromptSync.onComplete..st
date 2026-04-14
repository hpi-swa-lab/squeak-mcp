public
sendPromptSync: aString onComplete: aBlock
	"Send a prompt and wait for complete response.
	Block receives the full response text."
	self ensureSession: [
		self postPromptSync: aString onComplete: aBlock.
	].