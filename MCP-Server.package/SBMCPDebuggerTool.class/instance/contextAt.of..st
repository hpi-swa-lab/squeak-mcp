frames
contextAt: frameOrNil of: aDebugger
	"The given frame, else the one selected in the debugger."
	^ frameOrNil
		ifNil: [aDebugger selectedContext]
		ifNotNil: [(self contextsOf: aDebugger) at: frameOrNil]