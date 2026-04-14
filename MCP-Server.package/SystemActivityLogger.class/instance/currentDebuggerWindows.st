error tracking
currentDebuggerWindows
	^ World submorphs select: [:m |
		(m isKindOf: SystemWindow) and: [m model isKindOf: Debugger]]