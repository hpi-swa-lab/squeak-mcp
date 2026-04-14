actions
onInputAccepted: aText
	"Called when user presses Enter in input field."
	inputText := aText asString.
	self submitCurrentInput.
	^ true