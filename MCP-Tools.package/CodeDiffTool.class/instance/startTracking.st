tracking
startTracking
	isTracking ifTrue: [^ self].
	isTracking := true.
	SystemChangeNotifier uniqueInstance
		notify: self
		ofAllSystemChangesUsing: #handleChange:.
	self changed: #trackingStatus