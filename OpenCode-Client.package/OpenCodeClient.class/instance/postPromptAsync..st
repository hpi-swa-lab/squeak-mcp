private
postPromptAsync: aString
	"Post prompt for async/streaming response."
	| path body |
	path := '/session/', sessionId, '/prompt_async'.
	body := self buildPromptBody: aString.
	[self httpPost: path json: body] fork.