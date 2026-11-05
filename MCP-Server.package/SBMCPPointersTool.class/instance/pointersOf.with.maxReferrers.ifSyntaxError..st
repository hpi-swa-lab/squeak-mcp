searching
pointersOf: expression with: anEvaluateTool maxReferrers: maxReferrers ifSyntaxError: aBlock
	"Runs in the evaluation's process. The object is only held by this frame: the frames of a running process cannot be reached from Smalltalk, and #inboundPointers leaves out its caller's frame. Answer only strings, so that nothing keeps the object after the search."
	| object referrers report path |
	object := [anEvaluateTool evaluate: expression in: nil]
		on: SyntaxErrorNotification do: [:ex |
			aBlock value: (anEvaluateTool syntaxErrorMessage: ex in: expression).
			^ nil].
	report := Dictionary new
		at: 'object' put: (self printValue: [object]);
		at: 'class' put: object class name;
		yourself.

	referrers := object inboundPointers.
	report
		at: 'directReferrerCount' put: referrers size;
		at: 'directReferrers' put: ((referrers first: (maxReferrers min: referrers size)) collect: [:each |
			each class name, ': ', (self printValue: [each])]) asArray.
	referrers := nil.

	path := (PointerFinder new goal: object; search; yourself) pointerList asArray
		collect: [:each | each asString].
	report at: 'path' put: path.
	path isEmpty ifTrue: [
		report at: 'note' put: 'There is no path from Smalltalk: the object is only referenced from process stacks (e.g. a suspended process), or it is garbage.'].
	^ report