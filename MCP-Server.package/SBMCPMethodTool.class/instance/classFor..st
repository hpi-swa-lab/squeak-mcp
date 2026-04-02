private
classFor: className
	"Return the class or an error string"
	| theClass |
	className isEmpty ifTrue: [^ 'class parameter is required'].

	theClass := (className endsWith: ' class')
		ifTrue: [
			(Smalltalk at: (className copyUpToLast: Character space) asSymbol ifAbsent: [nil])
				ifNotNil: [:c | c class]]
		ifFalse: [
			Smalltalk at: className asSymbol ifAbsent: [nil]].

		^ theClass ifNil: ['Class not found: ', className]