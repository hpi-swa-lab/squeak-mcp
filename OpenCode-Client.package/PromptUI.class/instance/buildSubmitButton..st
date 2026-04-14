ui
buildSubmitButton: aBuilder
	^ aBuilder pluggableButtonSpec new
		model: self;
		label: 'Submit';
		action: #onSubmitClicked;
		frame: (0.8@0.75 corner: 1@1)