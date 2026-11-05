inspecting
describeField: anInspectorField
	| description value |
	description := Dictionary new
		at: 'name' put: anInspectorField name asString;
		at: 'type' put: anInspectorField type;
		yourself.
	value := [anInspectorField value] on: Error do: [:ex |
		^ description at: 'error' put: (self errorMessageOf: ex); yourself].
	^ description
		at: 'value' put: (self printValue: [value]);
		at: 'class' put: value class name;
		yourself