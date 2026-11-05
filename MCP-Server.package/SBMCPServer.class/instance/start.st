server-control
start
	"Listen first; only a server that actually listens is remembered and becomes current."
	| webServer |
	webServer := WebServer new.
	webServer listenOn: port.
	webServer addService: '/mcp' action: [:req | self handleRequest: req].
	webServer startListener.
	server := webServer.
	self class current: self.
	SystemActivityLogger current startCapturing.
	Transcript show: 'MCP Server started on port ', port asString; cr.
	^ server