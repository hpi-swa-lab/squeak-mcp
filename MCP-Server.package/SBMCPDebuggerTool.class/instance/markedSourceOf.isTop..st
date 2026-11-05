frames
markedSourceOf: aContext isTop: aBoolean
	"The method source with the current statement in «», computed like Debugger>>pcRange. The source is the one the debugger map is built from, so that the range fits; it is decompiled for methods without source, e.g. do-its."
	| source range |
	source := [aContext method methodNode sourceText asString] on: Error do: [:ex | ^ '<no source: ', (self errorMessageOf: ex), '>'].
	range := [aContext debuggerMap
		rangeForPC: aContext pc
		in: aContext method
		contextIsActiveContext: aBoolean] on: Error do: [:ex | nil].
	(range isNil or: [range isEmpty or: [range last > source size]]) ifTrue: [^ source].
	^ (source copyFrom: 1 to: range first - 1), '«', (source copyFrom: range first to: range last), '»', (source copyFrom: range last + 1 to: source size)