mcp-protocol
handleToolsList: request id: id
	| tools |
	tools := self class availableTools collect: [:toolClass | toolClass asToolDefinition].
	^ self sendResult: request result: (Dictionary new at: 'tools' put: tools asArray; yourself) id: id