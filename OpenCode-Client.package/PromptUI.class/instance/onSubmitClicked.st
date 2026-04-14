actions
onSubmitClicked
	"Called when Submit button is clicked."
	(builder widgetAt: #inputArea) ifNotNil: [:w | w accept].