capturing
unregisterMouseCapture
	ActiveHand eventCaptureFilters:
		((ActiveHand eventCaptureFilters ifNil: [#()]) copyWithout: self)