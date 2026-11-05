private
stackFrom: aContext within: aBlock
	"The frames from aContext down to the evaluated expression (UndefinedObject>>DoIt) or to aBlock, whichever comes first."
	^ self
		stackFrom: aContext
		upTo: [:context |
			(context method selector == #DoIt and: [context closure isNil])
				or: [context closure == aBlock]]