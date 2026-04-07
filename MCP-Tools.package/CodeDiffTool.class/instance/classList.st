accessing
classList
	^ (self groupedChangesByMethod keys collect: [:name | name asString]) sorted