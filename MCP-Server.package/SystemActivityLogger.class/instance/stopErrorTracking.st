error tracking
stopErrorTracking
	steppingProcess ifNotNil: [
		steppingProcess terminate.
		steppingProcess := nil].
	knownDebuggers := Set new