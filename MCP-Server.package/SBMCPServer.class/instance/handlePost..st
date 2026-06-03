http-handling
handlePost: request
	| json method id params |
	json := Json readFrom: request getContent readStream.
	method := json at: 'method' ifAbsent: [''].
	id := json at: 'id' ifAbsent: [nil].
	params := json at: 'params' ifAbsent: [Dictionary new].

	MCPLogger default log: '>> POST method=', method printString, ' id=', id printString.

	method = 'initialize' ifTrue: [^ self handleInitialize: request id: id].
	method = 'tools/list' ifTrue: [^ self handleToolsList: request id: id].
	method = 'tools/call' ifTrue: [^ self handleToolsCall: request params: params id: id].

	MCPLogger default log: '!! unknown method: ', method printString.
	^ self sendError: request code: -32601 message: 'Method not found' id: id