debuggers
debuggerList
	^ Dictionary new
		at: 'debuggers' put: (self debuggerWindows collect: [:each |
			Dictionary new
				at: 'id' put: (self idOf: each);
				at: 'label' put: each label asString;
				at: 'top' put: each model interruptedContext printString;
				at: 'selectedFrame' put: each model contextStackIndex;
				yourself]) asArray;
		yourself