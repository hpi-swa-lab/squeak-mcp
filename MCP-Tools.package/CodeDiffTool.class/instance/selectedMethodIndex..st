accessing
selectedMethodIndex: anIndex
	selectedMethodIndex := anIndex.
	self changed: #selectedMethodIndex.
	self changed: #detailText