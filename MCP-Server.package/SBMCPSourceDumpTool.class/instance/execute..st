executing
execute: arguments
	| path directory categoriesToExport stats |
	path := self from: arguments get: 'path' ifAbsent: [''].
	path isEmpty ifTrue: [
		^ self errorResult: 'path parameter is required'].

	directory := FileDirectory on: path.
	directory assureExistence.

	categoriesToExport := self categoriesForExport.
	categoriesToExport isEmpty ifTrue: [
	^ self errorResult: 'No categories found to export'].

	stats := self exportCategories: categoriesToExport toDirectory: directory.

	^ self successResult: stats