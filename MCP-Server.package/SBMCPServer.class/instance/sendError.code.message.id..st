responses
sendError: request code: code message: message id: id
	| response |
	response := Dictionary new
		at: 'jsonrpc' put: '2.0';
		at: 'id' put: id;
		at: 'error' put: (Dictionary new
			at: 'code' put: code;
			at: 'message' put: message;
			yourself);
		yourself.
	^ self sendJson: request content: response