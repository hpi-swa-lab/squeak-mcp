actions
revertAllChanges
	"Revert ALL tracked changes across all classes"
	| grouped wasTracking |
	grouped := self groupedChangesByMethod.
	wasTracking := isTracking.
	self stopTracking.

	[grouped keysAndValuesDo: [:className :classMethods |
		classMethods keysAndValuesDo: [:selector :methodChanges |
			| sortedChanges firstChange isClassChange |
			sortedChanges := methodChanges sorted: [:a :b | (a at: #timestamp) < (b at: 				#timestamp)].
			sortedChanges isEmpty ifFalse: [
				firstChange := sortedChanges first.
				isClassChange := selector = '<class>'.
				isClassChange
					ifTrue: [self revertAllClassChanges: firstChange for: className]
					ifFalse: [self revertAllMethodChanges: firstChange for: className selector: 						selector]]]].
	changes := OrderedCollection new]
		ensure: [wasTracking ifTrue: [self startTracking]].

	selectedClassIndex := 0.
	selectedMethodIndex := 0.
	self changed: #classList.
	self changed: #methodList.
	self changed: #detailText