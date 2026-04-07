initialization
initialize
	super initialize.
	changes := OrderedCollection new.
	selectedClassIndex := 0.
	selectedMethodIndex := 0.
	isTracking := false