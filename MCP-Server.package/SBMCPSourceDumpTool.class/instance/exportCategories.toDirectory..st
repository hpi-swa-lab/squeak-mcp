private
exportCategories: categories toDirectory: directory
	| created updated skipped errors |
	created := OrderedCollection new.
	updated := OrderedCollection new.
	skipped := OrderedCollection new.
	errors := OrderedCollection new.

	categories do: [:category |
		[| result |
		result := self exportCategory: category toDirectory: directory.
		result = #created ifTrue: [created add: category].
		result = #updated ifTrue: [updated add: category].
		result = #skipped ifTrue: [skipped add: category]]
			on: Error
			do: [:ex | errors add: (category -> ex messageText)]].

	^ Dictionary new
		at: 'created' put: created asArray;
		at: 'updated' put: updated asArray;
		at: 'skipped' put: skipped asArray;
		at: 'errors' put: (errors collect: [:assoc |
			Dictionary new
				at: 'category' put: assoc key;
				at: 'error' put: assoc value;
				yourself]) asArray;
		at: 'totalCategories' put: categories size;
		yourself