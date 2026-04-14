initialization
initialize
	log := OrderedCollection new.
	maxEntries := 50.
	isCapturing := false.
	knownDebuggers := Set new.
	steppingProcess := nil