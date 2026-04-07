accessing
groupedChangesByMethod
	"Returns Dictionary: className -> (Dictionary: selector|'<class>' -> OrderedCollection of 	changes)"
	| grouped |
	grouped := Dictionary new.
	changes do: [:change |
		| className selector classDict methodChanges |
		className := change at: #className.
		selector := (change at: #type) = #method
			ifTrue: [change at: #selector]
			ifFalse: ['<class>'].
		classDict := grouped at: className ifAbsentPut: [Dictionary new].
		methodChanges := classDict at: selector ifAbsentPut: [OrderedCollection new].
		methodChanges add: change].
	^ grouped