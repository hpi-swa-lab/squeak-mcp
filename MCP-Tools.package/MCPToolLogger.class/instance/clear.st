actions
clear
	entries := OrderedCollection new.
	selectedIndex := 0.
	self changed: #toolList.
	self changed: #detailText.
	self changed: #statsText