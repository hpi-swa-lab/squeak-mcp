error tracking
startErrorTracking
	steppingProcess ifNotNil: [steppingProcess terminate].
	knownDebuggers := self currentDebuggerWindows asSet.
	steppingProcess := [
		[isCapturing] whileTrue: [
		self checkForNewDebuggers.
		(Delay forMilliseconds: 200) wait]] fork