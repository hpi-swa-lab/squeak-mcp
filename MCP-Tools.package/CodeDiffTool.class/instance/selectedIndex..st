accessing
selectedIndex: anIndex
	selectedClassIndex := anIndex.
	selectedMethodIndex := 0.
	self changed: #selectedIndex.
	self changed: #methodList.
	self changed: #detailText