error reporting
printFrame: aContext on: aStream
	aStream nextPutAll: aContext printString; cr.
	aStream tab; nextPutAll: 'self: '; nextPutAll: (self printValue: [aContext receiver]); cr.
	aContext tempNames doWithIndex: [:name :index |
		aStream tab; nextPutAll: name; nextPutAll: ': ';
			nextPutAll: (self printValue: [aContext namedTempAt: index]); cr]