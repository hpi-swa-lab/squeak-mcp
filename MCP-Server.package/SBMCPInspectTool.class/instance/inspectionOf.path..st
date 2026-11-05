inspecting
inspectionOf: anObject path: path
	"Answer the fields of the object at path, or a Dictionary with 'error' if path does not lead anywhere."
	| object |
	object := anObject.
	path do: [:name | | fields |
		fields := self fieldsOf: object.
		object := (fields
			detect: [:each | each name asString = name]
			ifNone: [^ Dictionary new
				at: 'error' put: 'No field ', name printString, ' in ', (self printValue: [object]), '; its fields are ', (fields collect: [:each | each name asString]) asArray printString;
				yourself]) value].
	^ Dictionary new
		at: 'path' put: path;
		at: 'object' put: (self printValue: [object]);
		at: 'class' put: object class name;
		at: 'fields' put: ((self fieldsOf: object) collect: [:each | self describeField: each]) asArray;
		yourself