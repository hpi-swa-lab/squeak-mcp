results
isClassComment: aMethodReference
	"Source searches also find class comments, as references with the selector #Comment."
	^ aMethodReference selector == #Comment
		and: [(aMethodReference actualClass includesSelector: #Comment) not]