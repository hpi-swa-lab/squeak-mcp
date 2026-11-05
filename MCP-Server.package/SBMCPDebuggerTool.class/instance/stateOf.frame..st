frames
stateOf: aDebuggerWindow frame: frameOrNil
	"The stack, and the details of the given or else the selected frame."
	| debugger contexts detailed state |
	debugger := aDebuggerWindow model.
	contexts := self contextsOf: debugger.
	detailed := frameOrNil ifNil: [debugger contextStackIndex].
	state := Dictionary new
		at: 'debugger' put: (self idOf: aDebuggerWindow);
		at: 'label' put: aDebuggerWindow label asString;
		at: 'selectedFrame' put: debugger contextStackIndex;
		at: 'frameCount' put: contexts size;
		at: 'frames' put: ((contexts first: (self class maxFrames min: contexts size)) withIndexCollect: [:each :index |
			index printString, ': ', each printString]) asArray;
		yourself.
	(detailed between: 1 and: contexts size) ifTrue: [
		state at: 'frame' put: (self detailsOf: (contexts at: detailed) number: detailed)].
	^ state