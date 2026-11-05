session results
clearSessionResults
	"Results are only kept so that a client could look at them again while it is connected; nothing needs them after the server stops or the image is saved."
	SessionResults := nil