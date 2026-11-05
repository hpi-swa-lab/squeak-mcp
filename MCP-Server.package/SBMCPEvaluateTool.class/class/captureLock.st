transcript capturing
captureLock
	^ CaptureLock ifNil: [CaptureLock := Mutex new]