responses
sendToolResult: request content: contentItems id: id
	| response |
	response := Dictionary new
		at: 'jsonrpc' put: '2.0';
		at: 'id' put: id;
		at: 'result' put: (Dictionary new at: 'content' put: contentItems asArray; yourself);
		yourself.
	^ self sendJson: request content: response