instance creation
reset
	Current ifNotNil: [:c | c stopCapturing].
	Current := nil