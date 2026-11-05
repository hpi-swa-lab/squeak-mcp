server-control
stop
	server ifNotNil: [
		server destroy.
		server := nil.
		SystemActivityLogger current stopCapturing.
		Transcript show: 'MCP Server stopped'; cr].
	self class current == self ifTrue: [self class current: nil].
	SBMCPEvaluateTool clearSessionResults