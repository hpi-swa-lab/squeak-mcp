private
scaled: aForm toFit: maxSize
	"Scale down only; Form>>scaledToSize: keeps the aspect ratio."
	(aForm width max: aForm height) <= maxSize ifTrue: [^ aForm].
	^ aForm scaledToSize: maxSize @ maxSize