private
processEventLine: aLine
	"Parse and dispatch a single SSE line."
	| line json |
	aLine ifNil: [^ self].
	line := aLine utf8ToSqueak withBlanksTrimmed.
	line ifEmpty: [^ self].

	(line beginsWith: 'data:') ifTrue: [
		line := (line allButFirst: 5) withBlanksTrimmed.
	].


	(line isEmpty or: [line first ~= ${]) ifTrue: [^ self].

	json := [STONJSON fromString: line] ifError: [^ self].
	self dispatchEvent: json.