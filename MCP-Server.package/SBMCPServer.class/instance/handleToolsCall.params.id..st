mcp-protocol
handleToolsCall: request params: params id: id
	| toolName arguments toolClass tool result |
	toolName := params at: 'name' ifAbsent: [''].
	arguments := params at: 'arguments' ifAbsent: [Dictionary new].

	MCPLogger default log: '>> tools/call name=', toolName printString, ' args=', arguments printString.

	toolClass := self class availableTools
		detect: [:each | each toolName = toolName]
		ifNone: [
			MCPLogger default log: '!! unknown tool: ', toolName printString.
			^ self sendError: request code: -32602 message: 'Unknown tool: ', toolName id: id].

	tool := toolClass new.
	MCPLogger default log: '.. executing ', toolName printString.
	result := [tool execute: arguments] on: Error do: [:ex |
		MCPLogger default log: '!! ', toolName printString, ' ERROR: ', ex messageText printString.
		tool errorResult: ex messageText].
	MCPLogger default log: '<< ', toolName printString, ' returned result'.

	[MCPToolLogger current logTool: toolName arguments: arguments result: result]
		on: Error do: [:ex | "ignore logging errors"].

	self sendToolResult: request result: result id: id.
	MCPLogger default log: '== ', toolName printString, ' response sent'.
	^ result