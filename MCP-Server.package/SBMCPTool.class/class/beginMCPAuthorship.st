author initials
beginMCPAuthorship
	"Requests run in their own processes and may overlap. Only the first one switches to the MCP initials; the user's initials are remembered once."
	self authorLock critical: [
		(ActiveAuthorships ifNil: [0]) = 0 ifTrue: [
			UserInitials := self userInitialsFrom: Utilities authorInitials.
			Utilities authorInitials: (self mcpAuthorInitialsFor: UserInitials)].
		ActiveAuthorships := (ActiveAuthorships ifNil: [0]) + 1]