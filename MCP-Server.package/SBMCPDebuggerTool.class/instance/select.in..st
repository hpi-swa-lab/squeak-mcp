actions
select: frame in: aDebugger
	"Select frame like a click in the stack list, but never deselect it. The list may show only the top of the stack; expand it if needed."
	frame > aDebugger contextStackList size ifTrue: [aDebugger fullStack].
	aDebugger contextStackIndex = frame ifFalse: [aDebugger toggleContextStackIndex: frame]