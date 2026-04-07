tracking
toggleTracking
	isTracking
		ifTrue: [self stopTracking]
		ifFalse: [self startTracking]