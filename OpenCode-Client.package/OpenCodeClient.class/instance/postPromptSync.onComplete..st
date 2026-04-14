private
postPromptSync: aString onComplete: aBlock
	"Post prompt and wait for complete response."
	| path body |
	path := '/session/', sessionId, '/message'.
	body := self buildPromptBody: aString.

	[
		| response data text |
		response := self httpPost: path json: body.
		response isSuccess ifTrue: [
			data := self parseJson: response content.
			text := self extractTextFrom: data.
			WorldState addDeferredUIMessage: [aBlock value: text].
		] ifFalse: [
			self logError: 'Prompt failed' response: response.
		].
	] fork.