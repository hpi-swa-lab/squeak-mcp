ui
buildInputArea: aBuilder
	^ aBuilder pluggableTextSpec new
		model: self;
		name: #inputArea;
		getText: #inputText;
		setText: #onInputAccepted:;
		frame: (0@0.75 corner: 0.8@1)