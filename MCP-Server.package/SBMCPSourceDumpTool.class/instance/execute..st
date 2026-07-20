executing
execute: arguments
	| path directory categoriesToExport stats warnings |
	path := self from: arguments get: 'path' ifAbsent: [''].
	path isEmpty ifTrue: [
		^ self errorResult: 'path parameter is required'].

	directory := FileDirectory on: path.
	warnings := OrderedCollection new.

	directory exists ifTrue: [
		self hasOSProcess
			ifTrue: [self makeWritable: path]
			ifFalse: [warnings add: 'OSProcess not installed - cannot manage directory permissions']].

	directory assureExistence.

	categoriesToExport := self categoriesForExport.
	categoriesToExport isEmpty ifTrue: [
		^ self errorResult: 'No categories found to export'].

	stats := self exportCategories: categoriesToExport toDirectory: directory.

	self hasOSProcess ifTrue: [
		self makeReadOnly: path].

	warnings ifNotEmpty: [
		stats at: 'warnings' put: warnings asArray].

	^ self successResult: stats