accessing
contentsFrom: aPosition
	"The output written after aPosition, e.g. by one of several overlapping evaluates."
	^ stream contents allButFirst: aPosition