error tracking
checkForNewDebuggers
	| current new |
	current := self currentDebuggerWindows.
	new := current reject: [:w | knownDebuggers includes: w].
	new do: [:w |
		self logError: w label.
		knownDebuggers add: w].
		knownDebuggers := knownDebuggers select: [:w | w owner notNil]