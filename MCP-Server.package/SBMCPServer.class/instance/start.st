server-control
start
	"Start the MCP server on this instance's port.
	Stops any listener this instance already holds first, so calling start
	twice on the same instance does not leak a listener."

	self stop.

	server := WebServer new.
	server addService: '/mcp' action: [:req | self handleRequest: req].
	server listenOn: port.

	MCPLogger default log: 'MCP Server started on port ', port asString.
	Transcript show: 'MCP Server started on port ', port asString; cr.
	^ server