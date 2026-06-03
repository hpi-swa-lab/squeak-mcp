mcp-protocol
handleToolsList: request id: id
	| tools |
	MCPLogger default log: '.. tools/list id=', id printString.
	tools := self class availableTools collect: [:toolClass | toolClass asToolDefinition].
	MCPLogger default log: '<< tools/list collected ', tools size printString, ' tools'.
	self sendResult: request result: (Dictionary new at: 'tools' put: tools asArray; yourself) id: id.
	MCPLogger default log: '== tools/list response sent'.
	^ tools