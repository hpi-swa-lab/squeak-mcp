converting
asToolDefinition
	"Return the complete tool definition for MCP tools/list response"
	^ Dictionary new
		at: 'name' put: self toolName;
		at: 'description' put: self description;
		at: 'inputSchema' put: self inputSchema;
		yourself