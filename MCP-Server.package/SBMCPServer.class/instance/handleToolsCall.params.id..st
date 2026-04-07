mcp-protocol
handleToolsCall: request params: params id: id
	| toolName arguments toolClass tool result |
	toolName := params at: 'name' ifAbsent: [''].
	arguments := params at: 'arguments' ifAbsent: [Dictionary new].

	toolClass := self class availableTools
		detect: [:each | each toolName = toolName]
		ifNone: [^ self sendError: request code: -32602 message: 'Unknown tool: ', toolName id: id].

	tool := toolClass new.
	result := [tool execute: arguments] on: Error do: [:ex | tool errorResult: ex messageText].
	
	[MCPToolLogger current logTool: toolName arguments: arguments result: result]
		on: Error do: [:ex | "ignore logging errors"].

	^ self sendToolResult: request result: result id: id