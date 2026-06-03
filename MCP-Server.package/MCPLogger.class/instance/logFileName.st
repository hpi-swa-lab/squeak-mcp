accessing
logFileName
	^ logFileName ifNil: [logFileName := 'squeakmcp.log']