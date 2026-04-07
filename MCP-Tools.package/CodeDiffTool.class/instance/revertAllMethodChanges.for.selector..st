actions
revertAllMethodChanges: firstChange for: className selector: selector
	| targetClass changeKind |
	targetClass := Smalltalk at: className asSymbol ifAbsent: [^ self].
	changeKind := firstChange at: #changeKind.

	changeKind = #Added ifTrue: [
		(targetClass includesSelector: selector) ifTrue: [
			targetClass removeSelector: selector].
		^ self].

	(#(#Modified #Removed) includes: changeKind) ifTrue: [
		(firstChange at: #oldSource ifAbsent: []) ifNotNil: [:source |
			targetClass compile: source].
		^ self]