ui
buildWith: aBuilder
	| window |
	window := aBuilder pluggableWindowSpec new
		model: self;
		label: 'OpenCode Chat';
			children: {
				self buildDisplayArea: aBuilder.
				self buildInputArea: aBuilder.
				self buildSubmitButton: aBuilder.
			}.
	^ aBuilder build: window