mcp-protocol
handleInitialize: request id: id
	| result |
	result := Dictionary new
		at: 'protocolVersion' put: '2024-11-05';
		at: 'serverInfo' put: (Dictionary new
			at: 'name' put: 'SqueakMCP';
			at: 'version' put: '1.0.0';
			yourself);
		at: 'capabilities' put: (Dictionary new
			at: 'tools' put: Dictionary new;
			yourself);
		yourself.
	^ self sendResult: request result: result id: id