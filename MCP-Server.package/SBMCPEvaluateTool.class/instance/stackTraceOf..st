private
stackTraceOf: anException
	"The frames from where anException was signaled down to the evaluated expression (UndefinedObject>>DoIt)."
	^ self
		stackFrom: anException signalerContext
		upTo: [:context | context method selector == #DoIt and: [context closure isNil]]