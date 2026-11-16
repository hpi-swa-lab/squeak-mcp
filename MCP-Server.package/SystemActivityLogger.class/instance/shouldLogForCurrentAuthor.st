private
shouldLogForCurrentAuthor
	^ (Utilities authorInitials includesSubstring: SBMCPTool mcpAuthorInitials) not