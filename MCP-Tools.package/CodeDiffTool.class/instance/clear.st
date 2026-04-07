actions
clear
	changes := OrderedCollection new.
	selectedClassIndex := 0.
	selectedMethodIndex := 0.
	self changed: #classList.
	self changed: #methodList.
	self changed: #detailText