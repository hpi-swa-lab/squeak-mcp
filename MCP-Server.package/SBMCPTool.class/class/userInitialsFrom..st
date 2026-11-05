author initials
userInitialsFrom: initials
	"Strip any MCPServer (...) wrappers, also nested ones left over by older versions."
	| prefix result |
	prefix := self mcpAuthorInitials, ' ('.
	result := initials.
	[(result beginsWith: prefix) and: [result endsWith: ')']]
		whileTrue: [result := result copyFrom: prefix size + 1 to: result size - 1].
	^ result