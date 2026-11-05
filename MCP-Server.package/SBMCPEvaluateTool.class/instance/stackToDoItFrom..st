private
stackToDoItFrom: aContext
	"The frames from aContext down to the evaluated expression (UndefinedObject>>DoIt)."
	^ self
		stackFrom: aContext
		upTo: [:context | context method selector == #DoIt and: [context closure isNil]]