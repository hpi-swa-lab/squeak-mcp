http-handling
handlePost: request
	| json method id params |
	json := Json readFrom: request getContent readStream.
	method := json at: 'method' ifAbsent: [''].
	id := json at: 'id' ifAbsent: [nil].
	params := json at: 'params' ifAbsent: [Dictionary new].

	method = 'initialize' ifTrue: [^ self handleInitialize: request id: id].
	method = 'tools/list' ifTrue: [^ self handleToolsList: request id: id].
	method = 'tools/call' ifTrue: [^ self handleToolsCall: request params: params id: id].

	^ self sendError: request code: -32601 message: 'Method not found' id: id