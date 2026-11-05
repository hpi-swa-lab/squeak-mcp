private
stackTraceOf: anException
	"The frames from where anException was signaled down to the evaluated expression (UndefinedObject>>DoIt)."
	^ self stackToDoItFrom: anException signalerContext