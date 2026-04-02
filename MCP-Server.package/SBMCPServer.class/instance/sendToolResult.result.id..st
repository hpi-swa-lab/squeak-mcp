responses
sendToolResult: request result: result id: id
	| content response |
	content := {
		Dictionary new
			at: 'type' put: 'text';
			at: 'text' put: result asJsonString;
			yourself
	}.
	response := Dictionary new
		at: 'jsonrpc' put: '2.0';
		at: 'id' put: id;
		at: 'result' put: (Dictionary new at: 'content' put: content; yourself);
		yourself.
	^ self sendJson: request content: response