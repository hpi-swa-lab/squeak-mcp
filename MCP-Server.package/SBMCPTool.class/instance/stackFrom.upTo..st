error reporting
stackFrom: aContext upTo: lastFrameBlock
	"The frames from aContext down to the first one for which lastFrameBlock answers true, each with receiver, arguments and temporaries; at most maxStackFrames."
	| stream context count |
	stream := WriteStream on: String new.
	context := aContext.
	count := 0.
	[context notNil and: [count < self class maxStackFrames]] whileTrue: [
		self printFrame: context on: stream.
		(lastFrameBlock value: context) ifTrue: [^ stream contents].
		context := context sender.
		count := count + 1].
	context ifNotNil: [stream nextPutAll: '...'; cr].
	^ stream contents