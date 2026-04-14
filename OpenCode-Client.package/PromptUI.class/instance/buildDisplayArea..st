ui
buildDisplayArea: aBuilder
	^ aBuilder pluggableTextSpec new
		model: self;
		name: #displayArea;
		getText: #displayText;
		readOnly: true;
		frame: (0@0 corner: 1@0.75)