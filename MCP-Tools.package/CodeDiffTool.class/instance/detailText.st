accessing
detailText
	| grouped classNames className classMethods selectors selector methodChanges |
	grouped := self groupedChangesByMethod.
	classNames := grouped keys sorted.
	(selectedClassIndex between: 1 and: classNames size)
		ifFalse: [^ 'Select a class to see its changes'].

	className := classNames at: selectedClassIndex.
	classMethods := grouped at: className.
	selectors := classMethods keys sorted.
	(selectedMethodIndex between: 1 and: selectors size)
		ifFalse: [^ 'Select a method to see details'].

	selector := selectors at: selectedMethodIndex.
	methodChanges := classMethods at: selector.
	^ selector = '<class>'
		ifTrue: [self classDetailTextFor: className changes: methodChanges]
		ifFalse: [self methodDetailTextFor: className selector: selector changes: methodChanges]