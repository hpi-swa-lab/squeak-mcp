private
inUIProcess: aBlock
	"Draw in the UI process. If it does not get to it in time (busy or blocked), draw here."
	^ self
		inUIProcess: aBlock
		seconds: self class uiTimeoutSeconds
		ifTimedOut: [aBlock value]