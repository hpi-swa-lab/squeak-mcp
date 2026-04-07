accessing
toolList
	^ entries collect: [:entry |
		(entry at: #timestamp) asTime print24, ' - ', (entry at: #tool)]