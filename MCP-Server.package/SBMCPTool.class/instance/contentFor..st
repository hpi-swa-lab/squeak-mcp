results
contentFor: aResult
	"The MCP content items for aResult, the Dictionary answered by execute:. Tools that answer more than text, e.g. images, add their items."
	^ {Dictionary new
		at: 'type' put: 'text';
		at: 'text' put: aResult asJsonString;
		yourself}