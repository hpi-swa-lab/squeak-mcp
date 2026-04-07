accessing
reset
	SharedInstance ifNotNil: [:inst | inst stopTracking].
	SharedInstance := nil