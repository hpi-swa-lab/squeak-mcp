http-handling
contentOf: request
	"JSON is UTF-8 (RFC 8259). WebMessage decodes the content only if the Content-Type names a charset; MCP clients send just application/json."
	| content |
	content := request getContent.
	^ request textConverterForContentType
		ifNil: [content utf8ToSqueak]
		ifNotNil: [content]