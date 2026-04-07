actions
logTool: toolName arguments: arguments result: result
	| entry |
	isTracking ifFalse: [^ self].
	
	entry := Dictionary new
		at: #tool put: toolName;
		at: #arguments put: arguments copy;
		at: #result put: result;
		at: #timestamp put: DateAndTime now;
		yourself.
	entries addFirst: entry.
	self changed: #toolList.
	self changed: #statsText