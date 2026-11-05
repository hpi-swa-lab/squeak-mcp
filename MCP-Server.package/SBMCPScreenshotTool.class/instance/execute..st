executing
execute: arguments
	| expression maxSize morph form captured info |
	expression := self from: arguments get: 'morph' ifAbsent: [nil].
	maxSize := self from: arguments get: 'maxSize' ifAbsent: [self class defaultMaxSize].
	info := Dictionary new.
	(expression isNil or: [expression isEmpty])
		ifTrue: [
			form := self inUIProcess: [Display copy: Display boundingBox].
			info at: 'target' put: 'display']
		ifFalse: [ | outcome |
			outcome := SBMCPEvaluateTool new run: expression.
			(outcome at: 'success') ifFalse: [^ self addSystemChangesTo: outcome].
			morph := outcome at: #value.
			morph isMorph ifFalse: [
				^ self errorResult: 'The morph expression answered ', (morph printStringLimitedTo: 100), ', not a Morph'].
			form := self inUIProcess: [morph imageForm].
			info
				at: 'target' put: (morph printStringLimitedTo: 100);
				at: 'bounds' put: (self jsonRectangle: morph fullBounds)].
	captured := form extent.
	form := self scaled: form toFit: maxSize.
	png := self pngOf: form.
	^ self successResult: (info
		at: 'capturedWidth' put: captured x;
		at: 'capturedHeight' put: captured y;
		at: 'width' put: form width;
		at: 'height' put: form height;
		at: 'scale' put: (form width * 1000 / captured x) rounded / 1000.0;
		yourself)