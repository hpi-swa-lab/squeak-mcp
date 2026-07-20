server-control
start
	server := WebServer new.
	server listenOn: port.
	server addService: '/mcp' action: [:req | self handleRequest: req].
	server startListener.
	SystemActivityLogger current startCapturing. 
	Transcript show: 'MCP Server started on port ', port asString; cr.
	^ server