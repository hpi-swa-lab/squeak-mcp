executing
withMCPAuthorInitials: aBlock
	"Evaluate aBlock with author initials set to 'MCPServer (<original initials>)' and restore the original initials afterwards."
	| oldAuthor |
	oldAuthor := Utilities authorInitials.
	^ [Utilities authorInitials: self class mcpAuthorInitials, ' (', oldAuthor, ')'.
		aBlock value]
		ensure: [Utilities authorInitials: oldAuthor]