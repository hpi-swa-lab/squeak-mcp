system startup
shutDown: quitting
	"Do not save evaluate results into the image; they can keep large object graphs alive."
	self clearSessionResults