private
stackTraceOf: anException
	"The frames from where anException was signaled down to the evaluated expression (UndefinedObject>>DoIt), each with receiver, arguments and temporaries."
	| stream context count |
	stream := WriteStream on: String new.
	context := anException signalerContext.
	count := 0.
	[context notNil and: [count < self class maxStackFrames]] whileTrue: [
		self printFrame: context on: stream.
		(context method selector == #DoIt and: [context closure isNil]) ifTrue: [^ stream contents].
		context := context sender.
		count := count + 1].
	context ifNotNil: [stream nextPutAll: '...'; cr].
	^ stream contents