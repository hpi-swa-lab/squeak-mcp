author initials
userInitialsFrom: initials
	"Strip any -MCPServer suffixes, as well as MCPServer (...) wrappers left over by older versions, also nested ones."
	| suffix prefix result |
	suffix := '-', self mcpAuthorInitials.
	prefix := self mcpAuthorInitials, ' ('.
	result := initials.
	[(result endsWith: suffix)
		ifTrue: [result := result allButLast: suffix size. true]
		ifFalse: [((result beginsWith: prefix) and: [result endsWith: ')'])
			ifTrue: [result := result copyFrom: prefix size + 1 to: result size - 1. true]
			ifFalse: [false]]] whileTrue.
	^ result