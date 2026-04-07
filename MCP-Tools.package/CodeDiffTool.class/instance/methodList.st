accessing
methodList
	| grouped classNames className classMethods |
	grouped := self groupedChangesByMethod.
	classNames := grouped keys sorted.
	(selectedClassIndex between: 1 and: classNames size) ifFalse: [^ #()].

	className := classNames at: selectedClassIndex.
	classMethods := grouped at: className.

	^ classMethods keys sorted collect: [:selector |
		| methodChanges sortedChanges firstChange lastChange statusPrefix |
		methodChanges := classMethods at: selector.
		sortedChanges := methodChanges sorted: [:a :b |
			(a at: #timestamp) < (b at: #timestamp)].
		firstChange := sortedChanges first.
		lastChange := sortedChanges last.
		statusPrefix := (lastChange at: #changeKind) = #Removed
			ifTrue: ['[Deleted] ']
			ifFalse: [(firstChange at: #changeKind) = #Added
			ifTrue: ['[New] ']
			ifFalse: ['[Modified] ']].
		methodChanges size > 1
			ifTrue: [statusPrefix, selector asString, ' (', methodChanges size asString, ' changes)']
			ifFalse: [statusPrefix, selector asString]]