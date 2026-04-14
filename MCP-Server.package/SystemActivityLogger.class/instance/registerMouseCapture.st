capturing
registerMouseCapture
	ActiveHand eventCaptureFilters:
		((ActiveHand eventCaptureFilters ifNil: [#()]) copyWith: self)