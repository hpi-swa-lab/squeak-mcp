actions
revertAllClassChanges: firstChange for: className
	| changeKind |
	changeKind := firstChange at: #changeKind.

	changeKind = #Added ifTrue: [
		(Smalltalk at: className asSymbol ifAbsent: []) ifNotNil: [:cls |
			cls removeFromSystem].
		^ self].

	(#(#Modified #Removed) includes: changeKind) ifTrue: [
		(firstChange at: #oldDefinition ifAbsent: []) ifNotNil: [:def |
			Compiler evaluate: def].
		^ self].

	changeKind = #Commented ifTrue: [^ self]