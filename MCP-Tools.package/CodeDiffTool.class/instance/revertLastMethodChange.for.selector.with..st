actions
revertLastMethodChange: change for: className selector: selector with: allChanges
	| targetClass changeKind oldSource |
	targetClass := Smalltalk at: className asSymbol ifAbsent: [^ self].
	changeKind := change at: #changeKind.

	changeKind = #Added ifTrue: [
		(targetClass includesSelector: selector) ifTrue: [
			targetClass removeSelector: selector].
		^ self].

	changeKind = #Removed ifTrue: [
		oldSource := change at: #oldSource ifAbsent: [].
		oldSource ifNil: [
			allChanges reverseDo: [:c |
				oldSource ifNil: [
					oldSource := c at: #newSource ifAbsent: [c at: #oldSource ifAbsent: []]]]].
		oldSource ifNotNil: [targetClass compile: oldSource].
		^ self].

	changeKind = #Modified ifTrue: [
		(change at: #oldSource ifAbsent: []) ifNotNil: [:source |
			targetClass compile: source].
		^ self]