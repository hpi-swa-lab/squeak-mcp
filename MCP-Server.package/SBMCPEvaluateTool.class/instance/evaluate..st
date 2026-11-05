private
evaluate: expression
	"Like Compiler evaluate:, but the method keeps its temp names, so that stack traces show them. Without a requestor: one would turn on interactive error correction, i.e. dialogs."
	| method |
	method := (Compiler new
		compileNoPattern: expression
		in: UndefinedObject
		notifying: nil
		ifFail: [^ nil]) generateWithTempNames.
	^ nil withArgs: #() executeMethod: method