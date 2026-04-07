system-activities
prefixForActivityType: type
	"Return human-readable prefix for activity type"
	type = #mouseDown ifTrue: [^ 'The user clicked on: '].
	type = #error ifTrue: [^ 'An error occurred: '].
	type = #methodModified ifTrue: [^ 'The user modified the method: '].
	type = #methodAdded ifTrue: [^ 'The user added the method: '].
	type = #methodRemoved ifTrue: [^ 'The user removed the method: '].
	type = #classAdded ifTrue: [^ 'The user added the class: '].
	type = #classModified ifTrue: [^ 'The user modified the class: '].
	type = #classRemoved ifTrue: [^ 'The user removed the class: '].
	^ '[', type asString, '] '