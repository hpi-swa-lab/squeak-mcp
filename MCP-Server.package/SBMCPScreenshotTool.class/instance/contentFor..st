results
contentFor: aResult
	"The image first, then the size information as text. Without an image (an error), only the text."
	png ifNil: [^ super contentFor: aResult].
	^ {Dictionary new
			at: 'type' put: 'image';
			at: 'data' put: png base64Encoded;
			at: 'mimeType' put: 'image/png';
			yourself},
		(super contentFor: aResult)