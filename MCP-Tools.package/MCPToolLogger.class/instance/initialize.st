initialization
initialize
	super initialize.
	entries := OrderedCollection new.
	selectedIndex := 0.
	isTracking := false