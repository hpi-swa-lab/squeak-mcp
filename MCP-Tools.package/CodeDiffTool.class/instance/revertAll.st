actions
revertAll
	"Revert all changes for selected method back to original state"
	| grouped classNames className classMethods selectors selector methodChanges 	sortedChanges firstChange isClassChange wasTracking |
	grouped := self groupedChangesByMethod.
	classNames := grouped keys sorted.
	(selectedClassIndex between: 1 and: classNames size) ifFalse: [^ self].

	className := classNames at: selectedClassIndex.
	classMethods := grouped at: className.
	selectors := classMethods keys sorted.
	(selectedMethodIndex between: 1 and: selectors size) ifFalse: [^ self].

	selector := selectors at: selectedMethodIndex.
	methodChanges := classMethods at: selector.
	isClassChange := selector = '<class>'.
	sortedChanges := methodChanges sorted: [:a :b | (a at: #timestamp) < (b at: #timestamp)].
	sortedChanges isEmpty ifTrue: [^ self].

	firstChange := sortedChanges first.
	wasTracking := isTracking.
	self stopTracking.

	[isClassChange
		ifTrue: [self revertAllClassChanges: firstChange for: className]
		ifFalse: [self revertAllMethodChanges: firstChange for: className selector: selector].
	methodChanges do: [:change | changes remove: change ifAbsent: []]]
		ensure: [wasTracking ifTrue: [self startTracking]].

	self changed: #classList.
	self changed: #methodList.
	self changed: #detailText