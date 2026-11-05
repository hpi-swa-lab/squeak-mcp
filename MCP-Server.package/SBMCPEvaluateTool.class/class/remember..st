session results
remember: anObject
	"Keep anObject for later requests; answer the variable name to refer to it."
	| name |
	name := self generateVariableName.
	self sessionResults at: name put: anObject.
	^ name