actions
toggle
	| inst |
	inst := self current.
	inst ifNil: [
		inst := self on: self defaultPort.
		self current: inst].
	inst isRunning
		ifTrue: [inst stop]
		ifFalse: [inst start]