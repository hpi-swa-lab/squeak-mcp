private
writeHeaderFor: entry on: stream
	| timestamp |
	timestamp := entry at: #timestamp.
	stream
		nextPutAll: '==========================='; cr;
		nextPutAll: '  TOOL: '; nextPutAll: (entry at: #tool); cr;
		nextPutAll: '  DATE: '; nextPutAll: timestamp asDate printString; cr;
		nextPutAll: '  TIME: '; nextPutAll: timestamp asTime print24; cr;
		nextPutAll: '==========================='; cr; cr