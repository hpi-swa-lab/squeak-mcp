accessing
selectedIndex: anIndex
	selectedIndex := anIndex.
	self changed: #selectedIndex.
	self changed: #detailText