frames
detailsOf: aContext number: anInteger
	^ Dictionary new
		at: 'number' put: anInteger;
		at: 'method' put: aContext printString;
		at: 'source' put: (self markedSourceOf: aContext isTop: anInteger = 1);
		at: 'variables' put: (String streamContents: [:stream | self printFrame: aContext on: stream]);
		yourself