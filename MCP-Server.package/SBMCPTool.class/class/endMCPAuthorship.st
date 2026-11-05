author initials
endMCPAuthorship
	"Only the last running request switches back. If the user changed the initials in the meantime, keep theirs."
	self authorLock critical: [
		ActiveAuthorships := ((ActiveAuthorships ifNil: [1]) - 1) max: 0.
		(ActiveAuthorships = 0 and: [Utilities authorInitials = (self mcpAuthorInitialsFor: UserInitials)])
			ifTrue: [Utilities authorInitials: UserInitials]]