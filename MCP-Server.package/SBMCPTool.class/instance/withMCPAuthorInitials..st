author initials
withMCPAuthorInitials: aBlock
	"Evaluate aBlock with author initials set to 'MCPServer (<user initials>)' and restore the user's initials when the last overlapping request is done."
	self class beginMCPAuthorship.
	^ aBlock ensure: [self class endMCPAuthorship]