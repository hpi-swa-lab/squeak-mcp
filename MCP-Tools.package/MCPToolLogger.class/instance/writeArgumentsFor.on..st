private
writeArgumentsFor: entry on: stream
	stream nextPutAll: '--- ARGUMENTS ---'; cr.
	(entry at: #arguments) keysAndValuesDo: [:key :value |
		stream
			nextPutAll: '  '; nextPutAll: key asString; nextPutAll: ': '; cr;
			nextPutAll: '    '; nextPutAll: (value printString contractTo: 200); cr].
			stream cr