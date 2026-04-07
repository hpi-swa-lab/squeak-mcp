responses
sendResult: request result: result id: id
	| response |
	response := Dictionary new
		at: 'jsonrpc' put: '2.0';
		at: 'id' put: id;
		at: 'result' put: result;
		yourself.
	^ self sendJson: request content: response