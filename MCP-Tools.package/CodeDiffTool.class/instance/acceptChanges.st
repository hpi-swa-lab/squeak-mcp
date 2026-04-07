actions
acceptChanges
	"Accept (remove from tracking) changes for selected method"
	| grouped classNames className classMethods selectors selector methodChanges |
	grouped := self groupedChangesByMethod.
	classNames := grouped keys sorted.
	(selectedClassIndex between: 1 and: classNames size) ifFalse: [^ self].

	className := classNames at: selectedClassIndex.
	classMethods := grouped at: className.
	selectors := classMethods keys sorted.
	(selectedMethodIndex between: 1 and: selectors size) ifFalse: [^ self].

	selector := selectors at: selectedMethodIndex.
	methodChanges := classMethods at: selector.
	methodChanges do: [:change | changes remove: change ifAbsent: []].
	
	self changed: #classList.
	self changed: #methodList.
	self changed: #detailText