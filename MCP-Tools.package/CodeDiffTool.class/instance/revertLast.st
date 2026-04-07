actions
revertLast
	"Revert only the most recent change for selected method"
	| grouped classNames className classMethods selectors selector methodChanges sortedChanges 	lastChange isClassChange wasTracking |
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

	lastChange := sortedChanges last.
	wasTracking := isTracking.
	self stopTracking.

	[isClassChange
		ifTrue: [self revertLastClassChange: lastChange for: className with: sortedChanges]
		ifFalse: [self revertLastMethodChange: lastChange for: className selector: selector with: 			sortedChanges].
	changes remove: lastChange ifAbsent: []]
		ensure: [wasTracking ifTrue: [self startTracking]].

	self changed: #classList.
	self changed: #methodList.
	self changed: #detailText