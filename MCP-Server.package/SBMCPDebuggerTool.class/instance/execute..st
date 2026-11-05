executing
execute: arguments
	| action window frame |
	action := self from: arguments get: 'action' ifAbsent: [''].
	(self class actions includes: action) ifFalse: [
		^ self errorResult: 'action must be one of ', (self class actions inject: '' into: [:all :each | all isEmpty ifTrue: [each] ifFalse: [all, ', ', each]])].
	action = 'list' ifTrue: [^ self successResult: self debuggerList].

	window := self debuggerWindowFrom: arguments.
	window isString ifTrue: [^ self errorResult: window].
	frame := self integerFrom: arguments get: 'frame' ifAbsent: [nil].
	(frame notNil and: [(frame between: 1 and: (self contextsOf: window model) size) not]) ifTrue: [
		^ self errorResult: 'There is no frame ', frame printString, '; the stack has ', (self contextsOf: window model) size printString, ' frames'].

	action = 'stack' ifTrue: [^ self successResult: (self stateOf: window frame: frame)].
	action = 'evaluate' ifTrue: [
		^ self
			evaluate: (self from: arguments get: 'expression' ifAbsent: [''])
			in: (self contextAt: frame of: window model)].
	^ self act: action on: window frame: frame arguments: arguments