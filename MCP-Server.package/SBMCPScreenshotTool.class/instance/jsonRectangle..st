private
jsonRectangle: aRectangle
	^ Dictionary new
		at: 'x' put: aRectangle left;
		at: 'y' put: aRectangle top;
		at: 'width' put: aRectangle width;
		at: 'height' put: aRectangle height;
		yourself