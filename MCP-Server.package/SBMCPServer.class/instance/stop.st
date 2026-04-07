server-control
stop
	server ifNotNil: [
		server stopListener.
		server := nil.
		Transcript show: 'MCP Server stopped'; cr]