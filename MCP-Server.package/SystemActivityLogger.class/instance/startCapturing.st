capturing
startCapturing
	isCapturing ifTrue: [^ self].
	isCapturing := true.
	self registerSystemNotifications.
	self registerMouseCapture.
	self startErrorTracking