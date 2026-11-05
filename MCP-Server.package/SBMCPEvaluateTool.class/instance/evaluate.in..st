private
evaluate: expression in: aContextOrNil
	aContextOrNil ifNil: [^ self evaluate: expression].
	^ Compiler new
		evaluate: expression
		in: aContextOrNil
		to: aContextOrNil receiver
		notifying: nil
		ifFail: [nil]
		logged: false