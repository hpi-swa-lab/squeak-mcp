accessing
sharedInstance
	^ SharedInstance ifNil: [SharedInstance := self new]